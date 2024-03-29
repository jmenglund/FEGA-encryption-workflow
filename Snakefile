import os.path

from sys import platform


configfile: "config.yaml"

# Choose checksum command depending on the operating system
if platform == "linux" or platform == "linux2":
    MD5_COMMAND = "md5sum"
elif platform == "darwin":  # macOS
    MD5_COMMAND = "md5 -r"
else:
    raise OSError("Linux and macOS are the only platforms supported")

# Use pregenerated private key if a file path has been specified
if config["privateKeyFile"] is not None:
    PRIVATE_KEY_COMMMAND = " --sk " + config["privateKeyFile"]
else:
    PRIVATE_KEY_COMMMAND = ""


def get_list_of_files(dir_path, base_path):
    """
    List paths to all files in the directory, including files in
    subdirectories (but not the subdirectories themselves).

    Parameters
    ----------
    dir_path : str
        Path to directory for which all contained files should be listed.
    base_path : str
        Base path for constructing relative paths.
    """
    file_entries = os.listdir(dir_path)
    all_files = list()
    for entry in file_entries:
        full_path = os.path.join(dir_path, entry)
        if os.path.isdir(full_path):
            all_files = all_files + get_list_of_files(full_path, base_path)
        else:
            all_files.append(os.path.relpath(full_path, base_path))
    return all_files


INPUT_PATHS = get_list_of_files(config["inputDir"], config["inputDir"])


rule all:
    input:
        expand(
            "results/{relpath}.{format}",
            relpath=INPUT_PATHS, format=["c4gh", "md5", "c4gh.md5"])


rule encrypt_file:
    input:
        config["recipientPublicKeyFile"],
        config["inputDir"] + "/{relpath}"
    output:
        "results/{relpath}.c4gh"
    shell:
        "crypt4gh encrypt" + PRIVATE_KEY_COMMMAND
        + " --recipient_pk {input[0]} < {input[1]} > {output}"


rule calculate_unencrypted_checksum:
    input: config["inputDir"] + "/{relpath}"
    output: "results/{relpath}.md5"
    shell: MD5_COMMAND + " {input} > {output}"


rule calculate_encrypted_checksum:
    input: "results/{relpath}.c4gh"
    output: "results/{relpath}.c4gh.md5"
    shell: MD5_COMMAND + " {input} > {output}"
