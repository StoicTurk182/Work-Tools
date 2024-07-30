To uninstall a program using the msiexec.exe command, you'll need the product code (GUID) of the application you want to uninstall. The general command syntax is:

msiexec /x {QUID}/q (for silent unistall)

Copy code

msiexec /x {product-code}
Here’s a step-by-step guide to uninstall a program using this method:

Find the Product Code:

You can find the product code in the Windows Registry or by using tools like the "Windows Installer CleanUp Utility" or "WMIC".
To find the product code using WMIC, open Command Prompt and run:

cmd
Copy code
wmic product get name,identifyingnumber
This will list all installed products with their corresponding product codes.
Run the Uninstall Command:

Open Command Prompt as an administrator.
Use the msiexec command to uninstall the program:

cmd
Copy code
msiexec /x {product-code}
Replace {product-code} with the actual product code of the application you want to uninstall.


Example
If the product code of the application you want to uninstall is 12345678-90AB-CDEF-1234-567890ABCDEF, the command would be:
cmd
Copy code
msiexec /x {12345678-90AB-CDEF-1234-567890ABCDEF}

Note
Make sure you have administrative privileges to perform the uninstallation.
The product code is a unique identifier for each installed application and looks like a GUID (e.g., 12345678-90AB-CDEF-1234-567890ABCDEF).
If you have the product code of the application, replace it in the command, and you should be able to uninstall the program successfully.
