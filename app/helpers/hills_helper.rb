module HillsHelper

def climbed?(id)
   @climbed_ids.index(id) != nil
 end

end
