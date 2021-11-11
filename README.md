# FEGA-SE encryption workflow

A Snakemake workflow for encrypting files before uploading them to the Swedish
node of the European Federated Genome-Phenome Archive (FEGA-SE).

The workflow will produce FEGA-SE compliant encrypted files along with files
for the encrypted and unencrypted [MD5 checksums](https://en.wikipedia.org/wiki/MD5)
for each file to be submitted. The folder with the output (`results`) will
mirror the directory structure containing the original files. The actual
encryption is done by the [Crypt4GH Encryption Utility](https://github.com/EGA-archive/crypt4gh).

The tool will output three files per input file:

- file.c4gh (encrypted file)
- file.md5 (file md5 sum value file)
- file.c4gh.md5 (encrypted file md5 sum value file)

The FEGA-SE encryption workflow performs tasks similarly to the Java-based
application [EGACryptor](https://ega-archive.org/submission/tools/egacryptor),
which has been developed specifically for submissions to the central European
Genome-Phenome Archive (EGA).

## Prerequisites

In order to run the workflow on your files, you'll need to have the following
installed on your system:

- Python `3.6+`. An easy way to get Python working on your system is to install
  the free [Anaconda distribution](https://www.anaconda.com/products/individual).
- [Snakemake](https://snakemake.readthedocs.io)
- [Crypt4GH Encryption Utility](https://github.com/EGA-archive/crypt4gh)

## Running the workflow

1. Download the workflow directory with its content from GitHub and place it
  somewhere on your system so that the workflow has access to the files that
  you want to encrypt.
2. Download the [FEGA-SE public key file](https://github.com/NBISweden/EGA-SE-user-docs/blob/main/crypt4gh_key.pub)
  and place it so that the workflow can access it. This file contains the
  recipient's public key.
3. Edit the the configuration file `config.yaml`.
4. `cd` to the workflow top folder and perform a dry-run to test the workflow:

```
$ snakemake -n
```

5. Run the workflow by calling Snakemake with a specified number of cores to
  use, i.e:

```
$ snakemake --cores 1
```

## Licence

Apache License 2.0