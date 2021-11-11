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


def get_list_of_files(dir, base_path):
    """
    List paths to all files in the directory, including files in
    subdirectories (but not the subdirectories themselves).

    Parameters
    ----------

    dir : str
        Directory for which all contained files should be listed.
    base_path : str
        Base path for constructing relative paths.
    """
    file_entries = os.listdir(dir)
    all_files = list()
    for entry in file_entries:
        full_path = os.path.join(dir, entry)
        if os.path.isdir(full_path):
            all_files = all_files + get_list_of_files(full_path, base_path)
        else:
            all_files.append(os.path.relpath(full_path, base_path))
    return all_files


INPUT_FILES = get_list_of_files(config["inputDir"], config["inputDir"])


rule all:
    input:
        expand(
            "results/{filename}.{format}",
            filename=INPUT_FILES, format=["c4gh", "md5", "c4gh.md5"])


rule encrypt_file:
    input:
        config["recipientPublicKeyFile"],
        config["inputDir"] + "/{filename}"
    output:
        "results/{filename}.c4gh"
    shell:
        "crypt4gh encrypt" + PRIVATE_KEY_COMMMAND
        + " --recipient_pk {input[0]} < {input[1]} > {output}"


rule calculate_unencrypted_checksum:
    input: config["inputDir"] + "/{filename}"
    output: "results/{filename}.md5"
    shell: MD5_COMMAND + """ {input} | awk "{{ print \$1 }}" > {output}"""


rule calculate_encrypted_checksum:
    input: "results/{filename}.c4gh"
    output: "results/{filename}.c4gh.md5"
    shell: MD5_COMMAND + """ {input} | awk "{{ print \$1 }}" > {output}"""
