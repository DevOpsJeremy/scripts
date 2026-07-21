function status() {
  git status
}
function acp() {
  $MSG = "$args"
  if ([string]::IsNullOrWhitespace($MSG)) {
    $MSG = "Updates"
  }
  git status -s &&
    git add -A &&
    git status -s &&
    git commit -m "$MSG" &&
    git push
}