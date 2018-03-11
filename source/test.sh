assertion () {
	testname=$1
	actual=$2
	expected=$3
	if [ "$actual" != "$expected" ]
	then
		echo $testname failed
		echo "Actual: " $actual
		echo "Expected: " $expected
	else
		echo $testname succeded
	fi
}

echo {} > test.db

./kv test.db -k 'key' 2>&1| head -n 2  | grep "std\.json\.JSONException@std\/json\.d\([0-9]{3}\): Key not found: key" -E > /dev/null
assertion "Test 'key not exists'" $? 0

./kv test.db -k testSet -v testValue
assertion "Test 'set value then get'" $(./kv test.db -k testSet) "testValue"

./kv test.db -k testSet -v newTestValue
assertion "Test 'set value then set again then get'" $(./kv test.db -k testSet) "newTestValue"

./kv test.db -k testSet -v '' 2>&1| head -n 2  | grep "kv\.InvalidValueException@source\/kv\.d\([0-9]{2}\): value is an empty line" -E > /dev/null
assertion "Test 'value empty'" $? 0

./kv test.db -k testSet -d
./kv test.db -k 'testSet' 2>&1 | grep 'Database "test.db" not found.' > /dev/null
assertion "Test 'key was deleted and database as well'" $? 0

./kv test.db -k a -v b
assertion "Test 'delete non existent key'" $(./kv test.db -k aa -d) $(echo "")
assertion "Test 'existing key gets returned'" $(./kv -k a test.db) $(echo "b")

rm test.db
