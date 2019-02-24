copy_file "bin/setup", force: true
copy_file "bin/update", force: true
copy_file "bin/standardize", force: true
chmod "bin/setup", "+x"
chmod "bin/update", "+x"
chmod "bin/standardize", "+x"
