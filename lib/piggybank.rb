require 'open-uri'
require 'nokogiri'
require 'money'

class PiggyBank < Money::Bank::VariableExchange
  
  CURRENCIES = %w(EUR USD JPY BGN CZK DKK GBP HUF LTL LVL PLN RON SEK CHF NOK HRK RUB TRY AUD BRL CAD CNY HKD IDR INR KRW MXN MYR NZD PHP SGD THB ZAR)
  
  def initialize
    super
    use_rates_from(Time.now)
  end
  
  def fetch_rates
    unless Rate.where("created_at > ?", 1.day.ago).exists?
      doc = Nokogiri::XML(open('http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml'))
      r = Rate.new
      doc.search('Cube/Cube/Cube').each do |line|
        r[line.attribute('currency').value.to_sym] = line.attribute('rate').value.to_f
      end
      r.save!
    end
  end
  
  def use_rates_from(datetime)
    rate = Rate.where("created_at <= ?", datetime).order("created_at DESC").first
    unless rate.nil?
      CURRENCIES.each do |currency|
        add_rate("EUR", currency, rate[currency.to_sym])
      end
    else
      fetch_rates
      use_rates_from(Time.now)      
    end
  end
  
  def exchange_with(from, to_currency)
    use_rates_from(Time.now)
    rate = get_rate(from.currency, to_currency)
    unless rate
      from_base_rate = get_rate("EUR", from.currency)
      to_base_rate = get_rate("EUR", to_currency)
      rate = to_base_rate / from_base_rate
    end
    Money.new((from.cents * rate), to_currency)
  end
  
end
