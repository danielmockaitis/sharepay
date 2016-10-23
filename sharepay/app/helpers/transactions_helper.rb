module TransactionsHelper
   def change_title_label(title)
      if (params[:sort].to_s == title)
        return 'hilite'
      else
         return nil
      end
   end
end
