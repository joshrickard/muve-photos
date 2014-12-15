
class Object

  # Rails style helper method for determining
  # if an object is nil or empty
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end

end
