param(
    [Parameter(Mandatory=$false)]
    [string]$Message = "Update site"
)

# Stash any local changes to ignored files (safe-guard)
Write-Host "Staging all changes..."
git add -A

# Check if there's anything to commit
$changes = git status --porcelain
if (-not $changes) {
    Write-Host "No changes to commit."
    exit 0
}

Write-Host "Committing with message: $Message"
git commit -m $Message

# Get current branch
$currentBranch = git branch --show-current
if (-not $currentBranch) {
    Write-Host "Cannot determine current branch. Are you inside a git repo?"
    exit 1
}

Write-Host "Pushing to origin/$currentBranch..."
try {
    git push -u origin $currentBranch
    Write-Host "Push successful."
} catch {
    Write-Host "Push failed. Error: $_"
    exit 1
}