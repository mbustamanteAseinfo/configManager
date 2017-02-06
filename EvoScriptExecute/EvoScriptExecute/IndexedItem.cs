using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EvoScriptExecute
{
    class IndexedItem
    {
        Item value;
        int index;

        public Item Value
        {
            get
            {
                return value;
            }

            set
            {
                this.value = value;
            }
        }

        public int Index
        {
            get
            {
                return index;
            }

            set
            {
                index = value;
            }
        }
    }
}
