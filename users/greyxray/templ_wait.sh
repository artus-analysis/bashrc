
# https://stackoverflow.com/questions/356100/how-to-wait-in-bash-for-several-subprocesses-to-finish-and-return-exit-code-0
for job in `jobs -p`
do
    # echo $job
    wait $job || let "FAIL+=1"
done

# echo $FAIL

if [ "$FAIL" == "0" ];
then
    # echo "YAY!"
    return 0
else
    # echo "FAIL! ($FAIL)"
    return 1
fi
