this.stash_container <- {
	m = {
		Items = null,
		Capacity = null,
		ID = "",
		IsLocked = false,
		IsResizable = false
	},
	function getID()
	{
		return this.m.ID;
	}

	function setID( _id )
	{
		this.m.ID = _id;
	}

	function isLocked()
	{
		return this.m.IsLocked;
	}

	function setLocked( _value )
	{
		this.m.IsLocked = _value;
	}

	function getCapacity()
	{
		return this.m.Capacity;
	}

	function isResizable()
	{
		return this.m.IsResizable;
	}

	function setResizable( _value )
	{
		this.m.IsResizable = _value;
	}

	function resize( _size )
	{
		this.m.Items.resize(_size);
		this.m.Capacity = _size;
	}

	function create()
	{
		this.m.Capacity = 0;
		this.m.Items = [];
	}

	function isEmpty()
	{
		return this.m.Items.len() == 0;
	}

	function isSlotEmpty( _index )
	{
		if (_index >= 0 && _index < this.m.Items.len())
		{
			return this.m.Items[_index] == null;
		}

		return false;
	}

	function isValidSlot( _index )
	{
		if (_index >= 0 && _index < this.m.Items.len())
		{
			return true;
		}

		return false;
	}

	function hasEmptySlot()
	{
		for( local i = this.m.Items.len() - 1; i >= 0; i = --i )
		{
			if (this.m.Items[i] == null)
			{
				return true;
			}
		}

		return false;
	}

	function makeEmptySlots( _n )
	{
		local n = 0;

		for( local i = this.m.Items.len() - 1; i >= 0; i = --i )
		{
			if (this.m.Items[i] == null)
			{
				n = ++n;
			}

			if (n >= _n)
			{
				return;
			}
		}

		_n = _n - n;

		for( local j = 0; j < _n; j = ++j )
		{
			local lowestValue = 90000;
			local lowestIdx = -1;

			for( local i = this.m.Items.len() - 1; i >= 0; i = --i )
			{
				if (this.m.Items[i] == null)
				{
				}
				else if (this.m.Items[i].isItemType(this.Const.Items.ItemType.Named) || this.m.Items[i].isItemType(this.Const.Items.ItemType.Legendary) || this.m.Items[i].isItemType(this.Const.Items.ItemType.Food))
				{
				}
				else if (this.m.Items[i].getValue() < lowestValue)
				{
					lowestValue = this.m.Items[i].getValue();
					lowestIdx = i;
				}
			}

			if (lowestIdx >= 0)
			{
				this.m.Items[lowestIdx] = null;
			}
		}
	}

	function isLastTakenSlot( _index )
	{
		local startIndex = _index + 1;

		if (startIndex >= 0 && startIndex < this.m.Items.len())
		{
			for( local i = startIndex; i < this.m.Items.len(); i = ++i )
			{
				if (this.m.Items[i] != null)
				{
					return false;
				}
			}

			return true;
		}

		return false;
	}

	function getNumberOfEmptySlots()
	{
		local result = 0;

		for( local i = 0; i < this.m.Items.len(); i = ++i )
		{
			if (this.m.Items[i] == null)
			{
				result = ++result;
			}
		}

		return result;
	}

	function getNumberOfFilledSlots()
	{
		local result = 0;

		for( local i = 0; i < this.m.Items.len(); i = ++i )
		{
			if (this.m.Items[i] != null)
			{
				result = ++result;
			}
		}

		return result;
	}

	function getFirstEmptySlot()
	{
		for( local i = 0; i < this.m.Items.len(); i = ++i )
		{
			if (this.m.Items[i] == null)
			{
				return i;
			}
		}

		return null;
	}

	function getItemAtIndex( _index )
	{
		if (_index >= 0 && _index < this.m.Items.len())
		{
			return {
				item = this.m.Items[_index],
				index = _index
			};
		}

		return null;
	}

	function getItemByInstanceID( _instanceID )
	{
		for( local i = 0; i < this.m.Items.len(); i = ++i )
		{
			if (this.m.Items[i] != null && this.m.Items[i].getInstanceID() == _instanceID)
			{
				return {
					item = this.m.Items[i],
					index = i
				};
			}
		}

		return null;
	}

	function getItemByID( _id )
	{
		for( local i = 0; i < this.m.Items.len(); i = ++i )
		{
			if (this.m.Items[i] != null && this.m.Items[i].getID() == _id)
			{
				return this.m.Items[i];
			}
		}

		return null;
	}

	function getItems()
	{
		return this.m.Items;
	}

	function add( _item )
	{
		local idx = this.getFirstEmptySlot();

		if (idx != null)
		{
			this.m.Items[idx] = _item;

			if (_item != null)
			{
				_item.onAddedToStash(this.m.ID);
			}

			return idx;
		}
		else if (this.m.IsResizable)
		{
			this.m.Items.push(_item);

			if (_item != null)
			{
				_item.onAddedToStash(this.m.ID);
			}

			return this.m.Items.len() - 1;
		}

		return null;
	}

	function insert( _item, _index )
	{
		if (!this.isValidSlot(_index))
		{
			return null;
		}

		if (this.isSlotEmpty(_index))
		{
			this.m.Items[_index] = _item;
			_item.onAddedToStash(this.m.ID);
			return null;
		}
		else
		{
			local result = this.m.Items[_index];
			this.m.Items[_index] = _item;
			_item.onAddedToStash(this.m.ID);
			return result;
		}
	}

	function remove( _item )
	{
		if (typeof _item == "table")
		{
			_item = _item.getInstanceID();
		}

		local item = this.getItemByInstanceID(_item);

		if (item != null)
		{
			local result = this.m.Items[item.index];
			this.m.Items[item.index] = null;

			if (this.m.IsResizable)
			{
				this.m.Items.remove(item.index);
			}

			result.onRemovedFromStash(this.m.ID);
			return result;
		}

		return null;
	}

	function removeByIndex( _index )
	{
		local item = this.getItemAtIndex(_index);

		if (item != null && item.item != null)
		{
			local result = item.item;
			this.m.Items[item.index] = null;

			if (this.m.IsResizable)
			{
				this.m.Items.remove(item.index);
			}

			result.onRemovedFromStash(this.m.ID);
			return result;
		}

		return null;
	}

	function removeByID( _id )
	{
		for( local i = 0; i < this.m.Items.len(); i = ++i )
		{
			if (this.m.Items[i] != null && this.m.Items[i].getID() == _id)
			{
				local item = this.m.Items[i];
				this.m.Items[i] = null;

				if (this.m.IsResizable)
				{
					this.m.Items.remove(i);
				}

				item.onRemovedFromStash(this.m.ID);
				return item;
			}
		}

		return null;
	}

	function swap( _sourceIndex, _targetIndex )
	{
		if (_sourceIndex == _targetIndex)
		{
			return true;
		}

		if (this.isValidSlot(_sourceIndex) && this.isValidSlot(_targetIndex))
		{
			local sourceItem = this.m.Items[_sourceIndex];
			this.m.Items[_sourceIndex] = this.m.Items[_targetIndex];
			this.m.Items[_targetIndex] = sourceItem;
			return true;
		}

		return false;
	}

	function clear()
	{
		if (this.m.IsResizable)
		{
			this.m.Items = [];
		}
		else
		{
			for( local i = 0; i < this.m.Items.len(); i = ++i )
			{
				this.m.Items[i] = null;
			}
		}
	}

	function shrink()
	{
		if (!this.m.IsResizable)
		{
			return;
		}

		local newArray = [];
		local len = this.m.Items.len();

		for( local i = 0; i < this.m.Items.len(); i = ++i )
		{
			if (this.m.Items[i] != null)
			{
				newArray.push(this.m.Items[i]);
			}
		}

		this.m.Items = newArray;
	}

	function assign( _array )
	{
		this.m.Items = _array;
		this.m.Capacity = _array.len();
	}

	function sort()
	{
		this.m.Items.sort(this.onItemCompare);
	}

	function onItemCompare( _item1, _item2 )
	{
		if (_item1 == null && _item2 == null)
		{
			return 0;
		}
		else if (_item1 == null && _item2 != null)
		{
			return 1;
		}
		else if (_item1 != null && _item2 == null)
		{
			return -1;
		}
		else if (_item1.getItemType() > _item2.getItemType())
		{
			return -1;
		}
		else if (_item1.getItemType() < _item2.getItemType())
		{
			return 1;
		}
		else if (_item1.getCategories() > _item2.getCategories())
		{
			return -1;
		}
		else if (_item1.getCategories() < _item2.getCategories())
		{
			return 1;
		}
		else if (_item1.getID() > _item2.getID())
		{
			return -1;
		}
		else if (_item1.getID() < _item2.getID())
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}

	function onSerialize( _out )
	{
		_out.writeU16(this.m.Items.len());

		for( local i = 0; i != this.m.Items.len(); i = ++i )
		{
			local item = this.m.Items[i];

			if (item == null)
			{
				_out.writeBool(false);
			}
			else
			{
				_out.writeBool(true);
				_out.writeI32(item.ClassNameHash);
				item.onSerialize(_out);
			}
		}
	}

	function onDeserialize( _in )
	{
		this.clear();
		local numItems = _in.readU16();

		if (this.m.Items.len() < numItems)
		{
			this.m.Items.resize(numItems);
		}

		for( local i = 0; i < numItems; i = ++i )
		{
			local hasItem = _in.readBool();

			if (hasItem)
			{
				local item = this.new(this.IO.scriptFilenameByHash(_in.readI32()));
				item.onDeserialize(_in);
				this.m.Items[i] = item;
			}
		}
	}

};

