# FEGA-SE encryption workflow

A Snakemake workflow for encrypting files before uploading them to the Swedish
node of the Federated European Genome-Phenome Archive (FEGA-SE).

The workflow will produce FEGA-SE compliant encrypted files along with files
for the encrypted and unencrypted [MD5 checksums](https://en.wikipedia.org/wiki/MD5)
for each file in a specified input directory. The resulting output will be
placed in a separate folder (`results`) with the same directory structure as
the input folder. The actual encryption is done by the [Crypt4GH Encryption Utility](https://github.com/EGA-archive/crypt4gh).

The workflow will output three files per input file:

- `file.c4gh` (encrypted file)
- `file.md5` (file md5 sum value file)
- `file.c4gh.md5` (encrypted file md5 sum value file)

The FEGA-SE encryption workflow performs tasks analogously to the Java-based
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

1. Download the workflow from GitHub and place the directory with the files
   somewhere on your system so that the workflow has access to the files that
   you want to encrypt.
2. Download the [FEGA-SE public key file](https://github.com/NBISweden/EGA-SE-user-docs/blob/main/crypt4gh_key.pub)
   and place it so that the workflow can access it. This file contains the
   recipient's public key.
3. Edit the configuration file `config.yaml`. You need to specify the paths to
   your input directory and to the file with the recipient's public key.
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