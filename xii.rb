class VendingMachine
    def initialize(manufacturer_name)
      @amount = 0
      @stock = 100
      @manufacturer_name = manufacturer_name
    end
  
    def deposit_coin(coin)
      @amount += coin
    end
  
    def press_button(item)
      if @amount >= item.price
        @amount -= item.price
        return item.name
      end
    end
  
    def add_cup(num)
      if not (@stock + num) > 100
        @stock += num
      end
    end
  end
  
  class Item
    attr_reader :name, :price
    def initialize(name)
      @name = name
      @price = 0
    end
  end
  
  class Drink < Item
    def initialize(name)
      super(name)
      if name == 'cider'
        @price = 100
      elsif name == 'cola'
        @price = 150
      end
    end
  end
  
  class Coffee < Item
    def initialize(name)
      if name == 'hot'
        @name = 'hot cup coffe'
      elsif name == 'ice'
        @name = 'ice cup coffe'
      end
      @price = 100
    end
  end
  
  class Snack < Item
    def initialize()
      super('poteto chips')
      @price = 150
    end
  end
  
  hot_cup_coffee = Coffee.new('hot');
  cider = Drink.new('cider')
  snack = Snack.new
  vending_machine = VendingMachine.new('サントリー')
  vending_machine.deposit_coin(100)
  vending_machine.deposit_coin(100)
  puts vending_machine.press_button(cider)
  
  puts vending_machine.press_button(hot_cup_coffee)
  vending_machine.add_cup(1)
  puts vending_machine.press_button(hot_cup_coffee)
  
  puts vending_machine.press_button(snack)
  vending_machine.deposit_coin(100)
  vending_machine.deposit_coin(100)
  puts vending_machine.press_button(snack)