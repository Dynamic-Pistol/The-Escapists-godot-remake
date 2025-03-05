import configparser

def wrap_non_int_in_quotes(ini_file):
  """Wraps non-integer values in an INI file in quotes while preserving case.

  Args:
    ini_file: The path to the INI file.

  Returns:
    A string containing the modified INI file content.
  """

  config = configparser.ConfigParser()
  config.read(ini_file)

  modified_ini = ""
  for section in config.sections():
    modified_ini += f"[{section}]\n"
    for key, value in config[section].items():
      try:
        # Attempt to convert the value to an integer
        int(value)
        modified_ini += f"{key.capitalize()}={value}\n"
      except ValueError:
        # If conversion fails, wrap the value in quotes, preserving case
        modified_ini += f"{key.capitalize()}=\"{value}\"\n"
    modified_ini += "\n"

  return modified_ini

# Example usage
ini_file_path = "speech_eng.txt"  # Replace with your INI file path
modified_ini = wrap_non_int_in_quotes(ini_file_path)

# Optionally, write the modified content back to the file
with open(ini_file_path, "w") as f:
  f.write(modified_ini)
