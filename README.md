# tovmachine-com

Minimal portfolio website. Go visit [tovmachine.com](https://tovmachine.com).

## Resume

The resume is written with [markdown-resume](https://github.com/mtovmassian/markdown-resume),
included as a git submodule in `markdown-resume/`. The PDF published on the site lives in
`src/resume/Martin_Tovmassian_DevOps_Engineer.pdf`.

### Get the submodule

```sh
git clone --recurse-submodules https://github.com/mtovmassian/tovmachine-com.git
# or, in an existing clone
git submodule update --init
```

> [!NOTE]
> **Multiple GitHub accounts.** Remote URLs are plain `https://github.com/mtovmassian/...`.
> To push over SSH with a dedicated key, define a host alias in `~/.ssh/config`
> (`Host <alias>` / `Hostname github.com` / `IdentityFile ...`) and rewrite the URLs with a
> local `insteadOf`. Pass it with `-c` on the first clone (it also applies to the submodule
> clone), then persist it in both the repo and the submodule, which has its own config:
>
> ```sh
> RULE='url.git@<alias>:mtovmassian/.insteadOf'
> git -c "$RULE=https://github.com/mtovmassian/" clone --recurse-submodules \
>   https://github.com/mtovmassian/tovmachine-com.git
> cd tovmachine-com
> git config "$RULE" https://github.com/mtovmassian/
> git -C markdown-resume config "$RULE" https://github.com/mtovmassian/
> ```

### Edit the resume

The editor is a Nuxt app that stores resumes in the browser (IndexedDB/localStorage).
The source of truth is the database export tracked in
`markdown-resume/data/MARKDOWN_RESUME_data.json`.

1. Start the editor:

   ```sh
   cd markdown-resume
   pnpm install
   pnpm build:pkg
   pnpm dev   # http://localhost:3000/markdown-resume/
   ```

2. On the resumes list, use **Restore DB ...** and pick `data/MARKDOWN_RESUME_data.json`
   (skip this step if the browser already holds the latest version).
3. Edit the "Martin Tovmassian DevOps Engineer" resume.
4. Back on the resumes list, use **Backup DB ...** and overwrite
   `data/MARKDOWN_RESUME_data.json` with the downloaded file.
5. In the editor, use **Export PDF** and save it as PDF from the print dialog. The file is
   named after the resume (`Martin_Tovmassian_DevOps_Engineer.pdf`).

### Publish

1. Commit and push the changes in the submodule:

   ```sh
   cd markdown-resume
   git add data/MARKDOWN_RESUME_data.json
   git commit -m "update resume"
   git push
   ```

2. Copy the exported PDF to the site and record the new submodule commit:

   ```sh
   cd ..
   cp ~/Downloads/Martin_Tovmassian_DevOps_Engineer.pdf src/resume/
   git add markdown-resume src/resume/Martin_Tovmassian_DevOps_Engineer.pdf
   git commit -m "update resume"
   git push
   ```

3. Deploy the content only:

   ```sh
   cd ansible
   ansible-playbook playbook.yml --tags content
   ```
