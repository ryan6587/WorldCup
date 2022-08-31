#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != winner && $OPPONENT != opponent ]]
  then
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      TEAM2_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      if [[ -z $TEAM_ID ]]
      then
        TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $TEAM_INSERT = "INSERT 0 1" ]]
        then
            echo Added $WINNER
        fi
      fi
      if [[ -z $TEAM2_ID ]]
      then
        TEAM2_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $TEAM2_INSERT = "INSERT 0 1" ]]
        then
          echo Added $OPPONENT
        fi
      fi
  fi
  if [[ $YEAR != year && $ROUND != round && $WINNER_GOALS != winner_goals && $OPPONENT_GOALS != opponent_goals ]]
  then
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    TEAM2_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year = '$YEAR' AND winner_id = $TEAM_ID AND opponent_id = $TEAM2_ID")
    if [[ -z $GAME_ID ]]
    then
      GAME_INSERT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID, $TEAM2_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $GAME_INSERT = "INSERT 0 1" ]]
      then
        echo Added Game during $YEAR between $WINNER and $OPPONENT
      fi
    fi
  fi
done