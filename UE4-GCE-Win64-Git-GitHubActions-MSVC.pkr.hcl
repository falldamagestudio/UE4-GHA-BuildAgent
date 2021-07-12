
variable "image_name" {
  type    = string
  default = ""
}

variable "project_id" {
  type    = string
  default = ""
}

variable "source_image" {
  type    = string
  default = "windows-server-2019-dc-v20210608"
}

variable "zone" {
  type    = string
  default = ""
}

packer {
  required_plugins {
    windows-update = {
      version = "0.12.0"
      source = "github.com/rgl/windows-update"
    }
  }
}

source "googlecompute" "build_machine" {
  communicator = "winrm"
  disk_size    = "50"
  disk_type    = "pd-ssd"
  image_name   = "${var.image_name}"
  metadata = {
    windows-startup-script-cmd = "winrm quickconfig -quiet & net user /add packer_user & net localgroup administrators packer_user /add & winrm set winrm/config/service/auth @{Basic=\"true\"}"
  }
  project_id     = "${var.project_id}"
  source_image   = "${var.source_image}"
  state_timeout  = "10m"
  winrm_insecure = true
  winrm_use_ssl  = true
  winrm_username = "packer_user"
  zone           = "${var.zone}"
}

build {
  sources = ["source.googlecompute.build_machine"]

  provisioner "windows-update" {
  }
  
  provisioner "file" {
    destination = "C:\\"
    source      = "ImageCreation"
  }

  provisioner "file" {
    destination = "C:\\"
    source      = "Runtime"
  }

  provisioner "powershell" {
    inline = "try { C:\\ImageCreation\\Scripts\\InstallSoftware.ps1 } catch { Write-Error $_; exit 1 }"
  }

  provisioner "powershell" {
    inline = "try { C:\\ImageCreation\\Scripts\\GCERegisterServices.ps1 } catch { Write-Error $_; exit 1 }"
  }

  provisioner "powershell" {
    inline = "exit (Invoke-Pester -Script C:\\ImageCreation\\Scripts\\VerifyInstance.ps1 -PassThru).FailedCount"
  }

  provisioner "powershell" {
    inline = "Remove-Item -Force -Recurse C:\\ImageCreation"
  }

}
