#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | tail -n +2 | cut -d ',' -f 3,4 | tr ',' '\n' | sort -u | while read -r team; do
    echo $($PSQL "INSERT INTO teams (name) VALUES ('$team');")
done

cat games.csv | tail -n +2 | while IFS=',' read -r year round winner loser winner_goals loser_goals; do
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner';")
    loser_id=$($PSQL "SELECT team_id FROM teams WHERE name='$loser';")
    echo $($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$year', '$round', '$winner_id', '$loser_id', '$winner_goals', '$loser_goals');")
done
