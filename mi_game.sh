#to do list
#1 left right and down
#2 detect if moving onto grass or not, can only move onto grass
#3 enemies


not_end_game=$true;
your_xpos=8;
your_ypos=5;
cursor_xpos=0;
cursor_ypos=0;
grass="#";
tree="T";
you="Y";
whole_map="";
end_line="_";
screen_width=10;
screen_height=10;


##########  initial map creation and draw

while [ $cursor_ypos -lt $screen_height ]

        do
        this_line="";
        while [ $cursor_xpos -lt $screen_width ]
                do
                        if [ $((cursor_xpos+1)) == $your_xpos ] && [ $cursor_ypos == $your_ypos ]
                        then
                                this_line=$this_line$you
                        else
                                R=$(($RANDOM%6))
                                if [ $R == 1 ]|[ $R == 2 ]|[ $R == 3 ]
                                        then
                                                this_line=$this_line$grass
                                        else
                                                this_line=$this_line$tree
                                fi

                fi
                cursor_xpos=$((cursor_xpos+1))
                done
                cursor_ypos=$((cursor_ypos+1))
                cursor_xpos=0
                echo $this_line
                whole_map=$whole_map$this_line$end_line

        done
        echo " "
        echo " "
        cursor_ypos=0


while [ not_end_game ]


########################### choose player move below
        do
        echo "make a move: w, a, s ,d"
        this_line=""




        for (( i=0; i<${#whole_map}; i++ ));
                do
                        if [[ "${whole_map:$i:1}" == "_" ]]
                                then
                                        echo $this_line;
                                        this_line="";
                        else
                                        this_line=$this_line${whole_map:$i:1};
                        fi

                done


        old_pos=$(((($screen_width+1)*$your_ypos)+$your_xpos)
        read player_move
        if [ $player_move == "w" ]
                then

                        new_pos=$(((($screen_width+1)*($your_ypos-1))+$your_xpos))
                        your_ypos=$((your_ypos-1))

                        # update for new_pos
                        new_char="y"
                        prefix=${whole_map:0:$((new_pos-1))}
                        suffix=${whole_map:$new_pos}
                        whole_map="$prefix$new_char$suffix"

                        # update for old pos
                        new_char="#"
                        prefix=${whole_map:0:$((old_pos-1))}
                        suffix=${whole_map:$old_pos}
                        whole_map="$prefix$new_char$suffix"

                        echo $whole_map

        elif [ $player_move == "a" ]
                then
                        new_pos=$(((($screen_width+1)*($your_ypos))+$your_xpos-1))
                        your_ypos=$((your_ypos-1))
                        # update for new_pos
                        new_char="y"
                        prefix=${whole_map:0:$((new_pos-1))}
                        suffix=${whole_map:$new_pos}
                        whole_map="$prefix$new_char$suffix"

                       # update for old pos
                        new_char="#"
                        prefix=${whole_map:0:$((old_pos-1))}
                        suffix=${whole_map:$old_pos}
                        whole_map="$prefix$new_char$suffix"

                        u
        elif [ $player_move == "s" ]
                then
                        your_ypos=$your_ypos+1
                        whole_map[$your_xpos,$your_ypos-1]=$grass
                        whole_map[$your_xpos,$your_ypos]=$you
        elif [ $player_move == "d" ]
                then
                        your_xpos=$your_xpos+1
                        whole_map[$your_xpos-1,$your_ypos]=$grass
                        whole_map[$your_xpos,$your_ypos]=$you
                fi


######## do other moves below

