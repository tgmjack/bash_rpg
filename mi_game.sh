#!/bin/bash

# 1   absolute value for dx and dy in goblin spawner 
# 2   bow attacks 
# 3   goblin movement 
# 4   inventory
# 5   enemies dont come from the right 

average_number_of_frames_till_enemy_spawn=5;
not_end_game=$true;
your_xpos=6;
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
                                R=$(($RANDOM%5))
                                if [ $R == 0 ] || [ $R == 1 ] || [ $R == 2 ] || [ $R == 3 ]
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

output_line=""
new_output=" first turn "

health=10
sword_exp=0
bow_exp=0
turn_counter=0
inventory=("apple")
###################
### main game loop
###################


while [ not_end_game ]


########################### choose player move below
        do
        turn_counter=$((turn_counter+1))
        echo "==============    new turn    =============="
        echo " health = "$health"   sword exp = "$sword_exp"    bow exp = "$bow_exp"    turn = "$turn_counter
        echo "   .........      "
        echo $output_line;
        echo "   ........        "

        output_line=""
        echo "make a move: w, a, s ,d"
        echo "1 = attack with sword, hits all enemies within 1 tile"
        echo "2 = attack with bow, shoots an arrow at nearest enemy (takes 2 turns)"
        echo "i = inventory "
        this_line=""


##########################
####### draw map section 
##########################


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
        
        echo "y = you       # = grass        T = tree      G = golbin"
        old_pos=$((($screen_width + 1) * $your_ypos + $your_xpos))
        read player_move
####################
####### inventory
####################

                
        if [ $player_move == "i" ]
                then
                echo " "
                echo " "
                echo "#####   inventory below    #######"
                echo "#                                #"
                item_counter=0
                for item in "${inventory[@]}"; 
                        do
                        item_counter=$((item_counter+1))
                        extra_spaces=$((31-${#item}))
                        item_string="#$item_counter"
                        for ((i = 0; i < extra_spaces; i++)); 
                                do
                                item_string+=" "
                        done
                        echo "$item_string$item#"
                done
                echo "#0                      close bag#"
                echo "##################################"
                read inventory_choice
                if [ $inventory_choice == "0" ]
                        then
                        new_output=" you opened and closed your bag "
                        output_line=$output_line$new_output
                elif [ "${inventory[$inventory_choice - 1]}" == "apple" ]; 
                        then
                        new_output=" you ate an apple "
                        output_line=$output_line$new_output
                        health=$((health+3))
                        unset "inventory[$((inventory_choice - 1))]"
                else
                        echo " bugga"
                        echo "${inventory[$inventory_choice - 1]}"

                fi

#####################
#### player movement section
#####################


        
        elif [ $player_move == "w" ]
                then
                        new_pos=$(((($screen_width+1)*($your_ypos-1))+$your_xpos))
                        trimmed_map=$(echo "$whole_map" | xargs)
                        char_on=${trimmed_map:$new_pos-1:1}
                        if (( $your_ypos == 0 ))
                                then
                                        new_output=" YOU CANT WALK OFF THE EDGE "
                                        output_line=$output_line$new_output
                                        new_output=""
                        else
                                if [ "$char_on" == "T" ]
                                        then
                                                new_output="   YOU BUMPED INTO A TREE "
                                                output_line=$output_line$new_output
                                                new_output=""
                                else
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
                                        new_output="you moved up"
                                        output_line=$output_line$new_output
                                #        echo $whole_map
                                fi
                        fi

        elif [ $player_move == "a" ]
                then
                        new_pos=$(((($screen_width+1)*($your_ypos))+$your_xpos-1))
                        trimmed_map=$(echo "$whole_map" | xargs)
                        char_on=${trimmed_map:$new_pos-1:1}
                        if (( $your_xpos-1 == 0 ))
                                then
                                        new_output=" YOU CANT WALK OFF THE EDGE "
                                        output_line=$output_line$new_output
                                        new_output=""
                        else
                                if [ "$char_on" == "T" ]
                                        then
                                                new_output="   YOU BUMPED INTO A TREE "
                                                output_line=$output_line$new_output
                                                new_output=""
                                else
                                        your_xpos=$((your_xpos-1))
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
                                        new_output="you moved left"
                                        output_line=$output_line$new_output
                                fi
                        fi


        elif [ $player_move == "s" ]
                then
                        new_pos=$(((($screen_width+1)*($your_ypos+1))+$your_xpos))
                        trimmed_map=$(echo "$whole_map" | xargs)
                        char_on=${trimmed_map:$new_pos-1:1}
                        if (( $your_ypos+2 > $screen_height ))
                                then
                                        new_output=" YOU CANT WALK OFF THE EDGE "
                                        output_line=$output_line$new_output
                                        new_output=""
                        else
                                if [ "$char_on" == "T" ]
                                        then
                                                new_output="   YOU BUMPED INTO A TREE "
                                                output_line=$output_line$new_output
                                                new_output=""
                                else                        
                                        your_ypos=$((your_ypos+1))
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
                                        new_output="you moved down"
                                        output_line=$output_line$new_output
                                fi
                        fi
        elif [ $player_move == "d" ]
                then
                        new_pos=$(((($screen_width+1)*($your_ypos))+$your_xpos+1))
                        trimmed_map=$(echo "$whole_map" | xargs)
                        char_on=${trimmed_map:$new_pos-1:1}
                        if (( $your_xpos+1 > $screen_width ))
                                then
                                        new_output=" YOU CANT WALK OFF THE EDGE "
                                        output_line=$output_line$new_output
                                        new_output=""
                        else
                                if [ "$char_on" == "T" ]
                                        then
                                                new_output="   YOU BUMPED INTO A TREE "
                                                output_line=$output_line$new_output
                                                new_output=""
                                else
                                        your_xpos=$((your_xpos+1))

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
                                        new_output="you moved right"
                                        output_line=$output_line$new_output
                                fi
                        fi

#######################
#####  player attack section
#######################
        elif [ $player_move == "1" ]
                then
                        for ((x = -1; x <= 1; x++)); 
                                do
                                for ((y = -1; y <= 1; y++)); 
                                        do
                                        if [ "$x" != 0 ] || [ "$y" != 0 ]
                                                then
                                                this_x_were_attacking=$((your_xpos+x-1))
                                                this_y_were_attacking=$((your_ypos+y))
                                                attacking_pos=$(((($screen_width+1)*($this_y_were_attacking))+$this_x_were_attacking+1))
                                                trimmed_map=$(echo "$whole_map" | xargs)
                                                char_on=${trimmed_map:$attacking_pos-1:1}
                                                if [ "$char_on" == "g" ] || [ "$char_on" == "G" ]
                                                        then
                                                        echo "weve hit something "
                                                        echo $char_on
                                                        new_char="#"
                                                        prefix=${whole_map:0:$((attacking_pos-1))}
                                                        suffix=${whole_map:$attacking_pos}
                                                        whole_map="$prefix$new_char$suffix"
                                                        sword_exp=$((sword_exp+1))
                                                fi
                                        fi
                                done
                        done
                        

        
        
        
        else
                new_output=" invalid input "
                output_line=$output_line$new_output
        fi



#####################
####    goblin spawner section
#####################


        enemy_spawn_chooser=$(($RANDOM%$average_number_of_frames_till_enemy_spawn))
        echo $enemy_spawn_chooser"    !=     "$average_number_of_frames_till_enemy_spawn-1
        if (( $enemy_spawn_chooser == $average_number_of_frames_till_enemy_spawn-1 ))
                then
                        still_looking_for_good_spot_for_new_enemy=true
                        while $still_looking_for_good_spot_for_new_enemy;
                                do
                                edge_for_enemy_to_spawn=$(($RANDOM%4))
                                if [ $edge_for_enemy_to_spawn == 0 ]
                                        then
                                        x=0
                                        y=$(($RANDOM%screen_height))
                                        new_pos=$(((($screen_width+1)*($y))+$x+1))
                                        trimmed_map=$(echo "$whole_map" | xargs)
                                        char_on=${trimmed_map:$new_pos-1:1}
                                        echo "char_on"
                                        echo $char_on
                                        if [ $char_on == "#" ]
                                                then
                                                dx=($your_xpos-$x)
                                                dy=$your_ypos-$y
                                                echo " dx , dy "
                                                echo $dx
                                                echo $dy
                                                if [[ dx > 3 && dy > 3 ]]
                                                        then
                                                        # update map for G
                                                        new_char="G"
                                                        prefix=${whole_map:0:$((new_pos-1))}
                                                        suffix=${whole_map:$new_pos}
                                                        whole_map="$prefix$new_char$suffix"
                                                        still_looking_for_good_spot_for_new_enemy=false
                                                fi
                                        fi

                                elif [ $edge_for_enemy_to_spawn == 1 ]
                                        then
                                        echo " spawn top "
                                        x=$(($RANDOM%screen_width))
                                        y=0
                                        new_pos=$(((($screen_width+1)*($y))+$x+1))
                                        trimmed_map=$(echo "$whole_map" | xargs)
                                        char_on=${trimmed_map:$new_pos-1:1}
                                        if [ $char_on == "#" ]
                                                then
                                                dx=($your_xpos-$x)
                                                dy=($your_ypos-$y)
                                                if [[ dx > 3 && dy > 3 ]]
                                                        then
                                                        # update map for G
                                                        new_char="G"
                                                        prefix=${whole_map:0:$((new_pos-1))}
                                                        suffix=${whole_map:$new_pos}
                                                        whole_map="$prefix$new_char$suffix"
                                                        still_looking_for_good_spot_for_new_enemy=false
                                                fi
                                        fi
                                elif [ $edge_for_enemy_to_spawn == 2 ]
                                        then
                                        echo " spawn right "
                                        x=$screen_width
                                        y=$(($RANDOM%screen_height))
                                        new_pos=$(((($screen_width+1)*($y))+$x+1))
                                        trimmed_map=$(echo "$whole_map" | xargs)
                                        char_on=${trimmed_map:$new_pos-1:1}
                                        if [ $char_on == "#" ]
                                                then
                                                dx=($your_xpos-$x)
                                                dy=$your_ypos-$y
                                                if [[ dx > 3 && dy > 3 ]]
                                                        then
                                                        # update map for G
                                                        new_char="G"
                                                        prefix=${whole_map:0:$((new_pos-1))}
                                                        suffix=${whole_map:$new_pos}
                                                        whole_map="$prefix$new_char$suffix"
                                                        still_looking_for_good_spot_for_new_enemy=false
                                                fi
                                        fi


                                elif [ $edge_for_enemy_to_spawn == 3 ]
                                        then
                                        echo " spawn bottom "
                                        x=$(($RANDOM%screen_width))
                                        y=($screen_height-1)
                                        new_pos=$(((($screen_width+1)*($y))+$x+1))
                                        trimmed_map=$(echo "$whole_map" | xargs)
                                        char_on=${trimmed_map:$new_pos-1:1}
                                        echo $char_on
                                        echo $new_pos
                                        if [ $char_on == "#" ]
                                                then
                                                dx=($your_xpos-$x)
                                                dy=$your_ypos-$y
                                                if [[ dx > 3 && dy > 3 ]]
                                                        then
                                                        # update map for G
                                                        new_char="G"
                                                        prefix=${whole_map:0:$((new_pos-1))}
                                                        suffix=${whole_map:$new_pos}
                                                        whole_map="$prefix$new_char$suffix"
                                                        still_looking_for_good_spot_for_new_enemy=false
                                                fi
                                        fi

                                fi

                                done

        fi


#########################
##### goblin movement section
#########################




        done




######## do other moves below
