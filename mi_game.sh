not_end_game=$true;
your_xpos=5;
your_ypos=5;
cursor_xpos=0;
cursor_ypos=0;
grass="#";
tree="T";
you="Y";
whole_map="";
end_line="_";

while [ $cursor_ypos -lt 10 ]
        do


        this_line="";
        while [ $cursor_xpos -lt 10 ]
                do
                if [ $cursor_xpos == $your_xpos ] && [ $cursor_ypos == $your_ypos ]
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
                whole_map=$this_line$end_line

        done
        echo " "
        echo " "
        cursor_ypos=0

your_ypos = 5;
while [ not_end_game ]
        do
        echo "make a move: w, a, s ,d"
        this_line=""
        for char in $whole_map
                do
                        if [ char == "_" ]
                                then
                                        echo this_line;
                                        this_line="";
                        else
                                this_line=$this_line$char;
                        fi
                done
        read player_move
        if [ $player_move == "w" ]
                then
                        your_ypos=$((your_ypos-1))
                        whole_map[$your_xpos,$((your_ypos+1))]=$grass
                        whole_map[$your_xpos,$your_ypos]=$you
        elif [ $player_move == "a" ]
                then
                        your_xpos=$your_xpos-1
                        whole_map[$((your_xpos+1)),$your_ypos]=$grass
                        whole_map[$your_xpos,$your_ypos]=$you
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
        done