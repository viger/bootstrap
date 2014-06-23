#!/bin/sh
# git customize commmand
# @Author: Tom.Chen<viger@mchen.info>
# @GitHub: http://github.com/viger/bootstrap
# @Genrater Time: 2014-06-15
#
# @Useage:
# plz set the file in ur home director, and add this command in ur .bashrc. and then execute : source ~/.bashrc
# source ~/.git-custom-command.sh
# alias gpl=git_pull_this_branch
# alias gpo=git_push_this_branch
# alias gcm=git_commit_this_branch
# alias ghelp=git_custom_help
# alias gck=git_checkout_to_feature
# alias gfb=git_flow_feature_start_branch

git_checkout_to_feature() {
  git branch -a | grep $1 | awk 'match($0, /feature\/rm[0-9A-Za-z_]+/){print substr($0,RSTART,RLENGTH)}' | head -n 1 | xargs git checkout
}

git_flow_feature_start_branch(){
    current_branch=$(cat .git/HEAD)
    explanation=`echo $2 | awk '{gsub(/ /, "_");print $0;}'`
    if [ ! $3 ]; then
        uname=`whoami`
    else
        uname=$3
    fi

    if [ "ref: refs/heads/develop" = "$current_branch" ]; then
        git pull origin develop && git flow feature start "rm$1_`date +%Y%m%d`_${uname}_${explanation}"
    else
        echo "Are u sure u have commit current branch [Y/n]:"
        read sure_current
        if [ "n" = "$sure_current" ]; then
            echo "Please input comments for current:"
            read current_comments
            git commit -am "$current_comments"
        fi
        git checkout develop && git pull origin develop && git flow feature start "rm$1_`date +%Y%m%d`_${uname}_${explanation}"
    fi
}

git_pull_this_branch(){
    git_get_foces_branch | xargs git pull origin
}

git_commit_this_branch(){
    branch_sn=`cat .git/HEAD | awk 'match($0, /rm[0-9]+_/){print substr($0,RSTART+2,RLENGTH-3)}'`
    git commit -am "#${branch_sn} $1"
}

git_push_this_branch(){
    git_get_foces_branch | xargs git push origin
}

git_get_foces_branch(){
     cat .git/HEAD | awk 'match($0, /feature\/rm[0-9A-Za-z_]+/){print substr($0,RSTART,RLENGTH)}'
}

git_custom_help(){
    echo -e "gpl == git pull origin current_banrch"
    echo -e "gpo == git push origin current_banrch"
    echo -e "gcm [comments] == git commit -am  current_banrch comments"
    echo -e "gck [branch_number] == git checkout rm_[branch_number]_xxx"
    echo -e "gfb [branch_number] [explanation] == git flow feature start rm_[branch_number]_20140620_explanation"
    echo -e "ghelp == show help from custom"
}
