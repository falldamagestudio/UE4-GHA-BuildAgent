$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Get-GitHubActionsRunnerLatestVersionURI' {

	It "Retrieves the latest version from the GitHub Releases page" {

		Mock Invoke-WebRequest -ParameterFilter { $Uri -eq "https://api.github.com/repos/actions/runner/releases/latest" } { @{
			Content = ConvertTo-Json @{
				url = "https://api.github.com/repos/actions/runner/releases/26441443";
				assets_url = "https://api.github.com/repos/actions/runner/releases/26441443/assets";
				upload_url = "https://uploads.github.com/repos/actions/runner/releases/26441443/assets{?name,label}";
				html_url = "https://github.com/actions/runner/releases/tag/v2.262.1";
				id = 26441443;
				node_id = "MDc6UmVsZWFzZTI2NDQxNDQz";
				tag_name = "v2.262.1";
				target_commitish = "master";
				name = "v2.262.1";
				draft = "False";
				author = "@{login=github-actions[bot]; id=41898282; node_id=MDM6Qm90NDE4OTgyODI=; avatar_url=https://avatars2.githubusercontent.com/in/15368?v=4; gravatar_id=; url=https://api.github.com/users/github-actions%5Bbot%5D;
						   html_url=https://github.com/apps/github-actions; followers_url=https://api.github.com/users/github-actions%5Bbot%5D/followers; following_url=https://api.github.com/users/github-actions%5Bbot%5D/following{/other_user};
						   gists_url=https://api.github.com/users/github-actions%5Bbot%5D/gists{/gist_id}; starred_url=https://api.github.com/users/github-actions%5Bbot%5D/starred{/owner}{/repo};
						   subscriptions_url=https://api.github.com/users/github-actions%5Bbot%5D/subscriptions; organizations_url=https://api.github.com/users/github-actions%5Bbot%5D/orgs; repos_url=https://api.github.com/users/github-actions%5Bbot%5D/repos;
						   events_url=https://api.github.com/users/github-actions%5Bbot%5D/events{/privacy}; received_events_url=https://api.github.com/users/github-actions%5Bbot%5D/received_events; type=Bot; site_admin=False}";
				prerelease = "False";
				created_at = "2020-05-12T20:09:13Z";
				published_at = "2020-05-12T20:30:42Z";
				assets = "{@{url=https://api.github.com/repos/actions/runner/releases/assets/20667279; id=20667279; node_id=MDEyOlJlbGVhc2VBc3NldDIwNjY3Mjc5; name=actions-runner-linux-arm-2.262.1.tar.gz; label=; uploader=;
						   content_type=application/octet-stream; state=uploaded; size=56141391; download_count=140; created_at=2020-05-12T20:31:04Z; updated_at=2020-05-12T20:31:05Z;
						   browser_download_url=https://github.com/actions/runner/releases/download/v2.262.1/actions-runner-linux-arm-2.262.1.tar.gz}, @{url=https://api.github.com/repos/actions/runner/releases/assets/20667282; id=20667282;
						   node_id=MDEyOlJlbGVhc2VBc3NldDIwNjY3Mjgy; name=actions-runner-linux-arm64-2.262.1.tar.gz; label=; uploader=; content_type=application/octet-stream; state=uploaded; size=56132927; download_count=313; created_at=2020-05-12T20:31:06Z;
						   updated_at=2020-05-12T20:31:08Z; browser_download_url=https://github.com/actions/runner/releases/download/v2.262.1/actions-runner-linux-arm64-2.262.1.tar.gz},
						   @{url=https://api.github.com/repos/actions/runner/releases/assets/20667270; id=20667270; node_id=MDEyOlJlbGVhc2VBc3NldDIwNjY3Mjcw; name=actions-runner-linux-x64-2.262.1.tar.gz; label=; uploader=;
						   content_type=application/octet-stream; state=uploaded; size=75512630; download_count=9377; created_at=2020-05-12T20:30:45Z; updated_at=2020-05-12T20:30:53Z;
						   browser_download_url=https://github.com/actions/runner/releases/download/v2.262.1/actions-runner-linux-x64-2.262.1.tar.gz}, @{url=https://api.github.com/repos/actions/runner/releases/assets/20667275; id=20667275;
						   node_id=MDEyOlJlbGVhc2VBc3NldDIwNjY3Mjc1; name=actions-runner-osx-x64-2.262.1.tar.gz; label=; uploader=; content_type=application/octet-stream; state=uploaded; size=52602524; download_count=905; created_at=2020-05-12T20:30:53Z;
						   updated_at=2020-05-12T20:31:03Z; browser_download_url=https://github.com/actions/runner/releases/download/v2.262.1/actions-runner-osx-x64-2.262.1.tar.gz}...}";
				tarball_url = "https://api.github.com/repos/actions/runner/tarball/v2.262.1";
				zipball_url = "https://api.github.com/repos/actions/runner/zipball/v2.262.1";
				body = "blah blah redacted"
		} } }

		$LatestVersionDownloadURI = Get-GitHubActionsRunnerLatestVersionURI

		$LatestVersionDownloadURI | Should Be "https://github.com/actions/runner/releases/download/v2.262.1/actions-runner-win-x64-2.262.1.zip"
	}
}