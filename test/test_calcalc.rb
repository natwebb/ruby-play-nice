require 'test/unit'
require_relative 'helper'
require 'calcalc'

class CalendarCalculationTest < MiniTest::Unit::TestCase
#-------Zeller's Congruence Tests-------#
  def test_01_has_calc_method
    assert CalCalc.respond_to? :zeller
  end

  def test_02_calc_april_17th_2014
    h = CalCalc.zeller(17, 4, 2014)
    assert_equal(5, h)
  end

  def test_03_calc_february_29th_2000
    h = CalCalc.zeller(29, 2, 2000)
    assert_equal(3, h)
  end

  def test_04_calc_january_1st_2014
    h = CalCalc.zeller(1, 1, 2014)
    assert_equal(4, h)
  end

#-----Leap Year True/False Tests-----#
  def test_05_leap_1999
    refute CalCalc.leap?(1999)
  end

  def test_06_leap_2000
    assert CalCalc.leap?(2000)
  end

  def test_07_leap_1900
    refute CalCalc.leap?(1900)
  end

  def test_08_leap_2012
    assert CalCalc.leap?(2012)
  end

end
