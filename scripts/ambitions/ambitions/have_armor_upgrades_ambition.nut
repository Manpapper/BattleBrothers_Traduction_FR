this.have_armor_upgrades_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_armor_upgrades";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Mundane armors won\'t do for a real mercenary outfit.\nWe should adorn our gear with trophies of our deeds!";
		this.m.UIText = "Have at least 6 armors with attachments";
		this.m.TooltipText = "Have at least 6 armors with attachments in your possession. Buy them, loot them, or have a taxidermist craft them for you, then combine them with the armor of your men.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]When you took command of the company it was a ragtag band of men clinging for life, an ad hoc assembly of sellswords stitched together with nothing if not sheer stubbornness and absolute contempt for common sense. Now you watch as the men walk around like frayed revenants of an unworldly wild, their armor adorned with hideous scalps and pelts and bones, the ill-shapen recreation of conquest fitted such that others may know the %companyname% could not be sorted by any measure known to the earth whether it be monster or man.";
		this.m.SuccessButtonText = "This will serve us well.";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().Days <= 20)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local upgrades = 0;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Armor) && item.getUpgrade() != null)
			{
				upgrades = ++upgrades;
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null && item.isItemType(this.Const.Items.ItemType.Armor) && item.getUpgrade() != null)
			{
				upgrades = ++upgrades;
			}
		}

		if (upgrades > 6)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local upgrades = 0;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Armor) && item.getUpgrade() != null)
			{
				upgrades = ++upgrades;
			}
		}

		if (upgrades >= 6)
		{
			return true;
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null && item.isItemType(this.Const.Items.ItemType.Armor) && item.getUpgrade() != null)
			{
				upgrades = ++upgrades;
			}
		}

		return upgrades >= 6;
	}

	function onPrepareVariables( _vars )
	{
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

