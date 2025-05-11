#!/bin/bash

names=(
    "Alfa"
    "Anime"
    "Bravo"
    "Batman"
    "Charlie"
    "Catboy"
    "Catgirl"
    "Delta"
    "Deer"
    "Echo"
    "Easy"
    "Foxtrot"
    "Foxboy"
    "Foxgirl"
    "Golf"
    "Gomennasai"
    "Herobrine"
    "Hotel"
    "Icarus"
    "India"
    "Juliett"
    "Jumpy"
    "Kazakh"
    "Kilo"
    "Kyrgyz"
    "Ligma"
    "Lima"
    "Mike"
    "Monad"
    "Monoid"
    "Narnia"
    "November"
    "Oscar"
    "OwO"
    "Papa"
    "pwq"
    "QAnon"
    "Quebec"
    "Rizzler"
    "Romeo"
    "Sierra"
    "Sigma"
    "Tango"
    "TwT"
    "Uniform"
    "UwU"
    "Uzbek"
    "Victor"
    "Victoria"
    "WAP"
    "Whiskey"
    "X-Ray"
    "XXX"
    "Yankee"
    "Yiff"
    "Zulu"
    "Goida"
)

if [[ " ${names[*]} " =~ " $2 " ]]; then
    echo "echo -markup '{Error}$1 is already randomized'"
    exit 0
fi

num_strings=${#names[@]}
random_index=$((RANDOM % num_strings))
name=${names[$random_index]}
if [[ $1 == "client" ]]; then
    echo "rename-client $name"
elif [[ $1 == "session" ]]; then
    echo "rename-session $name"
fi
