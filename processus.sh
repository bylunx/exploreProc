 #!/usr/bin/env bash
chemin="/tmp"
touch "$chemin/proc.dot"
> "$chemin/proc.dot"

echo "digraph mon_graphe {" >> "$chemin/proc.dot"

ps xao comm,pid,ppid,%mem |
while read line; do
  if ! [[ $line == *"PID"* ]]; then
    name=$(echo $line | cut -d " " -f1 | tr -d ' ')
    pid=$(echo $line | cut -d " " -f2 | tr -d ' ')
    ppid=$(echo $line | cut -d " " -f3 | tr -d ' ')
    int=$(echo $line | cut -d " " -f4 | tr -d ' ')
    taille=$(echo "scale=4; ($int+1)" | bc)

    if [ -n "$ppid" -a -n "$pid" ]; then
      echo "$pid [label=\"$name $pid\"];$ppid->$pid;$pid [height=$taille];$pid [width=$taille]; $pid [shape=\"box\"];" >> "$chemin/proc.dot"
    fi
fi
done
 echo "}" >> "$chemin/proc.dot"

dot "$chemin/proc.dot" -Tsvg -o"$chemin/toto.svg"