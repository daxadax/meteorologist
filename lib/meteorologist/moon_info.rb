class MoonInfo
  # This service is built for the 'moonPhase' variable in the DarkSky API
  # where a 'new' moon is 0 (0.99, 0, and 0.01)
  # and a 'full' moon is 0.5 (0.49 - 0.51)

  EMOJI = {
    'new'           => '🌑',
    'crescent'      => '🌒',
    'first quarter' => '🌓',
    'gibbous'       => '🌔',
    'full'          => '🌕',
    'disseminating' => '🌖',
    'last quarter'  => '🌗',
    'balsamic'      => '🌘'
  }.freeze

  def initialize(cycle_completion)
    @cycle_completion = cycle_completion
  end

  def illumination
    return 0 if new?
    return 1 if full?
    if waxing?
      ((cycle_completion / 0.48) - 0.01).round(2)
    else
      (1 - ((cycle_completion - 0.51) / 0.48)).round(2)
    end
  end

  def waxing?
    cycle_completion.between?(0.02, 0.48)
  end

  def waning?
    cycle_completion.between?(0.51, 0.98)
  end

  def phase_name
    return 'new' if new?
    return 'full' if full?

    if waxing?
      return 'crescent' if crescent?
      return 'first quarter' if quarter?
      return 'gibbous' if gibbous?
    else
      return 'disseminating' if gibbous?
      return 'last quarter' if quarter?
      return 'balsamic' if crescent?
    end
  end

  def in_sign
    #MoonSignCalculator.calculate(date)
  end

  def active_elements
    return []
    @active_elements ||= build_active_elements
  end

  def emoji
    EMOJI[phase_name]
  end


  private
  attr_reader :cycle_completion

  def new?
    cycle_completion > 0.98 || cycle_completion < 0.02
  end

  def crescent?
    cycle_completion.between?(0.02,0.23) || cycle_completion.between?(0.77,0.98)
  end

  def quarter?
    cycle_completion.between?(0.24,0.26) || cycle_completion.between?(0.74,0.76)
  end

  def gibbous?
    cycle_completion.between?(0.27,0.48) || cycle_completion.between?(0.52,0.73)
  end

  def full?
    cycle_completion.between?(0.49,0.51)
  end

  #def build_active_elements
  #  return ['water'] if new?
  #  return ['fire'] if full?

  #  elements = Array.new

  #  if waxing?
  #    elements.push('earth')
  #    elements.push('fire') if gibbous?
  #    elements.unshift('water') if crescent?
  #  else
  #    elements.push('air')
  #    elements.push('water') if crescent?
  #    elements.unshift('fire') if gibbous?
  #  end

  #  elements
  #end
end
