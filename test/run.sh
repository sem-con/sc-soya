#!/usr/bin/env bash

SOYACMD='soya'

# test validating flat JSON
echo '{"hello": "world"}' | soya validate Person > tmp.doc
if ! cmp -s tmp.doc checks/flat.doc ; then
	echo "error: validating flat JSON failed"
	rm tmp.doc
	exit 1
else
	echo "passed: flat JSON validation"
fi
rm tmp.doc

# test validation overlay
curl -k -s "https://playground.data-container.net/Person2instance" | soya validate Person2 > tmp.doc
if ! cmp -s tmp.doc checks/invalidPerson.json ; then
	echo "error: invalidPerson validation failed"
	rm tmp.doc
	exit 1
fi
rm tmp.doc

curl -k -s "https://playground.data-container.net/Person2valid" | soya validate Person2 > tmp.doc
if ! cmp -s tmp.doc checks/validPerson.json ; then
	echo "error: validPerson validation failed"
	rm tmp.doc
	exit 1
else
	echo "passed: validation layer checks"
fi
rm tmp.doc
