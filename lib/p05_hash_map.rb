require_relative 'p02_hashing'
require_relative 'p04_linked_list'

class HashMap
  include Enumerable

  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    @store[bucket(key)].include?(key)
  end

  def set(key, val)
    if @store[bucket(key)].include?(key)
      @store[bucket(key)].update(key,val)
    else
      if @count == num_buckets
        resize!
      end
      @store[bucket(key)].append(key,val)
      @count += 1

    end
  end

  def get(key)
    @store[bucket(key)].get(key)
  end

  def delete(key)
    @store[bucket(key)].remove(key)
    @count -= 1
  end

  def each(&prc)
    i = 0
    while i < @store.length
      curr_list = @store[i]
      curr_list.each do |link|
        prc.call(link.key, link.val)
      end
      i += 1
    end
   self
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    previous_num_buckets = num_buckets
    elements = {}
    self.each do |k, v|
      elements[k] = v
    end
    @store = Array.new((previous_num_buckets) * 2) {LinkedList.new}
    @count = 0
    elements.each do |k,v|
      set(k,v)
    end
  end


  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
    key.hash % num_buckets
  end
end
