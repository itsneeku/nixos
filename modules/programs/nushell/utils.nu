export def make-editable [
    path: string
] {
    let tmpdir = (mktemp -d)
    rsync -avz --copy-links $"($path)/" $tmpdir
    rsync -avz --copy-links --chmod=D2755,F744 $"($tmpdir)/" $path
}