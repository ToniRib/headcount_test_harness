require "minitest"
require "minitest/autorun"
require_relative "../../headcount/lib/district_repository"
require_relative "../../headcount/lib/district"
require_relative "../../headcount/lib/enrollment"
require_relative "../../headcount/lib/headcount_analyst"

class IterationOneTest < Minitest::Test
  def test_enrollment_repository_with_high_school_data
    er = EnrollmentRepository.new
    er.load_data({
                   :enrollment => {
                     :kindergarten => "./data/Kindergartners in full-day program.csv",
                     :high_school_graduation => "./data/High school graduation rates.csv"
                   }
                 })
    e = er.find_by_name("MONTROSE COUNTY RE-1J")


    expected = {2010=>0.738, 2011=>0.751, 2012=>0.777, 2013=>0.713, 2014=>0.757}
    assert_equal(expected, e.graduation_rate_by_year)
    assert_equal 0.738, e.graduation_rate_in_year(2010)
  end

  def test_high_school_versus_kindergarten_analysis
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
                                  :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.548, ha.kindergarten_participation_against_high_school_graduation('MONTROSE COUNTY RE-1J')
    assert_equal 0.800, ha.kindergarten_participation_against_high_school_graduation('STEAMBOAT SPRINGS RE-2')
  end
end
