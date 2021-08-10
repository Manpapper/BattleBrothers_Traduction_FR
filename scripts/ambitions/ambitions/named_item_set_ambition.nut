this.named_item_set_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.named_item_set";
		this.m.Duration = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "A famed company is recognized by their equipment. We should head out\nand claim a prestigious weapon, shield, armor and helmet to increase our renown.";
		this.m.UIText = "Have a famed weapon, shield, armor and helmet";
		this.m.TooltipText = "Have at least one famed weapon, shield, armor and helmet each in your possession. Follow rumors in taverns to learn where famed items can be found, purchase them at specialized shops in large cities and castles, or go out on your own to explore and raid ruins and camps. The further away from civilization, the higher the chance of finding rare items.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]After weeks spent listening for rumors, buying pints of beer for decrepit old veterans, and negotiating with wheedling crones, you were able to ferret out the locations of a prestigious weapon, shield, armor and helmet. Having learned where to find the pieces, all that remained was the minor matter of defeating the various horrors and cutthroats guarding it. Now soon to be worn by the men of your company, the pieces form a set fearsome to behold. %SPEECH_ON%The man who dons this arming onto the battlefield will see the fiercest enemy hobble away shaking a load down the leg of his pants!%SPEECH_OFF%%randombrother% exclaims proudly and to the laughing approval of his brothers in arms. You only hope their joy and excitement doesn\'t turn into envy once you announce which man will get to wear the pieces.";
		this.m.SuccessButtonText = "This will serve us well.";
	}

	function getNamedItems()
	{
		local ret = {
			Weapon = false,
			Shield = false,
			Armor = false,
			Helmet = false,
			Items = 0
		};
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)) && item.getID() != "armor.head.fangshire")
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Weapon))
				{
					ret.Weapon = true;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Shield))
				{
					ret.Shield = true;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Armor))
				{
					ret.Armor = true;
				}
				else if (item.isItemType(this.Const.Items.ItemType.Helmet))
				{
					ret.Helmet = true;
				}
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Weapon))
				{
					ret.Weapon = true;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

			if (item != null && item != "-1" && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Shield))
				{
					ret.Shield = true;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)) && item.getID() != "armor.head.fangshire")
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Helmet))
				{
					ret.Helmet = true;
				}
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				++ret.Items;

				if (item.isItemType(this.Const.Items.ItemType.Armor))
				{
					ret.Armor = true;
				}
			}

			for( local i = 0; i < bro.getItems().getUnlockedBagSlots(); i = ++i )
			{
				local item = bro.getItems().getItemAtBagSlot(i);

				if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
				{
					++ret.Items;

					if (item.isItemType(this.Const.Items.ItemType.Weapon))
					{
						ret.Weapon = true;
					}
					else if (item.isItemType(this.Const.Items.ItemType.Shield))
					{
						ret.Shield = true;
					}
					else if (item.isItemType(this.Const.Items.ItemType.Armor))
					{
						ret.Armor = true;
					}
					else if (item.isItemType(this.Const.Items.ItemType.Helmet))
					{
						ret.Helmet = true;
					}
				}
			}
		}

		return ret;
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.getTime().Days <= 50)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 5)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local named = this.getNamedItems();

		if (named.Items == 0)
		{
			return;
		}

		if (named.Weapon && named.Shield && named.Armor && named.Helmet)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local named = this.getNamedItems();

		if (named.Weapon && named.Shield && named.Armor && named.Helmet)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

