classdef CurrentState 
   enumeration
      Converting
      Stop 
   end
   methods 
       function state = isConverting(obj)
            state = (CurrentState.Converting == obj);
       end
   end
end

