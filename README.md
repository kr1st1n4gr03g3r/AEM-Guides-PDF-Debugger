# PDF Debugging

This is a PDF data extraction script based upon [QPDF](https://qpdf.readthedocs.io/en/stable/installation.html#build-instructions), [TIKA CLI](https://tika.apache.org/1.4/gettingstarted.html) to extract various PDF artifacts and content in order to debug DITA-processed print files that are extracted using AEM Guides and DITA-OT.

## Steps to install this script on Mac:

### Download the QPDF Binary
- Go to the official [QPDF releases page](https://github.com/qpdf/qpdf/releases).
- Download the macOS .tar.gz package from the latest release.
### Extract and Install
1. Open Terminal and navigate to your Downloads folder:
```bash
cd ~/Downloads
```
2. Extract the .tar.gz file (replace qpdf-x.x.x with the version you downloaded):
```bash
tar -xvzf qpdf-*-macos.tar.gz
```
3. Move the extracted folder somewhere permanent (like /usr/local/qpdf):
```bash
sudo mv qpdf-* /usr/local/qpdf
```
4. Add qpdf to your system's PATH (optional but useful):
```bash
echo 'export PATH=/usr/local/qpdf/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```
### Run QPDF
Now, you can check if it's installed correctly:

```bash
qpdf --version
```

Run this script to execute extraction from the folder of the input.pdf

`./extract_pdf_data.sh`
