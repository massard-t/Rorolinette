#########################
# Moulinette de norme
#
# Made by: riehli_r
##########################

##------------COLORS-------------

@blue = "\033[1;34m"
@red = "\033[1;31m"
@default = "\033[0m"

@file = 0
@error = 0

def checkSpaceBetweenKeyword
  @file.seek(0, IO::SEEK_SET)
  nbrLine = 1
  @file.each_line do |line| 
    if /^\s+[^\(]+[^\( ]+\(/.match(line)
      puts "----line #{@blue}#{nbrLine}#{@default} : Pas d'espace apres un mot cle"
      @error += 1
    end
    nbrLine += 1
  end
end

def checkSpaceAfterFct
  @file.seek(0, IO::SEEK_SET)
  nbrLine = 1
  @file.each_line do |line| 
    if /\(/.match(line) && !/if|while|for|return/.match(line) && / \(/.match(line)
      puts "----line #{@blue}#{nbrLine}#{@default} : Espace apres apres un appel fonction"
      @error += 1
    end
    nbrLine += 1
  end
end


def checkSpaceEndLine
  @file.seek(0, IO::SEEK_SET)
  nbrLine = 1
  @file.each_line do |line| 
    if /\s+\s$/.match(line)
      puts "----line #{@blue}#{nbrLine}#{@default} : Espace ou tabulation en fin de ligne"
      @error += 1
    end
    nbrLine += 1
  end
end

def checkLineLonger
  @file.seek(0, IO::SEEK_SET)
  nbrLine = 1
  @file.each_line do |line| 
    if line.size - 1 > 80
      puts "----line #{@blue}#{nbrLine}#{@default} : Ligne de #{line.size} caracteres"
      @error += 1
    end
    nbrLine += 1
  end
end

def checkFctSize
  @file.seek(0, IO::SEEK_SET)
  nbrLine = 1
  lineInFct = 0
  inFct = false
  @file.each_line do |line| 
    if /^{/.match(line) || (/{\s*$/.match(line) && !inFct)
      inFct = true
    elsif /^}/.match(line)
      inFct = false
      lineInFct = 0
    else
      if inFct
        lineInFct += 1
      end
      if lineInFct > 25
        puts "----line #{@blue}#{nbrLine}#{@default} : Fonction de plus de 25 lignes"
        @error += 1
      end
    end
    nbrLine += 1
  end
end

def checkHeader
  @file.seek(0, IO::SEEK_SET)
  nbrLine = 1
  @file.each_line do |line| 
    if nbrLine <= 6 && (line.split("")[0] != '/' || line.split("")[0] != '*')
      puts "----line #{@blue}#{nbrLine}#{@default} : Header incorrect"
      @error += 1
    end
    nbrLine += 1
  end
end

def checkFile(filename)
  @file = File.new(filename, 'r')
  checkHeader
  checkFctSize
  checkLineLonger
  checkSpaceEndLine
  checkSpaceBetweenKeyword
  checkSpaceAfterFct
end

Dir.foreach(".") do |file|
  if File.extname(file) == ".c" || File.extname(file) == ".h"
    puts "#{file}:"
    checkFile(file)
  end
end
puts "#{@red}#{@error}#{@default} erreurs."
