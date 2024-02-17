def fizz_buzz()
    #区切るための文字列を定義
    separator = ", "
    #数字を1から１００まで順に出力する
    for i in 1..100
      #３かつ５の倍数の時「FizzBuzz」と出力する
      if i % 15 == 0
        puts "FizzBuzz" + separator
      elsif i % 3 == 0
        puts "Fizz" + separator
      elsif i % 5 == 0
        puts "Buzz" + separator
      else
        puts i.to_s + separator
      end
    end
  end
  
  fizz_buzz()