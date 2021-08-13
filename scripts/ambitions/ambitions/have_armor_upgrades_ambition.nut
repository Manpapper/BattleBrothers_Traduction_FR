this.have_armor_upgrades_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_armor_upgrades";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Des armures banales ne suffisent pas pour une vraie tenue de mercenaire. Nous devrions orner notre équipement de trophées de nos exploits !";
		this.m.UIText = "Avoir au moins 6 armures avec des accessoires";
		this.m.TooltipText = "Ayez en votre possession au moins 6 armures avec des accessoires. Achetez-les, pillez-les ou demandez à un taxidermiste de vous les fabriquer, puis combinez-les avec les armures de vos hommes.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]Lorsque vous avez pris le commandement de la compagnie, c\'était un groupe d\'hommes en guenilles qui s\'accrochaient à la vie, un groupe de mercenaires assemblé sur le moment n\'ayant rien d\'autre que de l\'obstination et un mépris absolu pour le bon sens. Aujourd\'hui, vous regardez les hommes se promener comme des revenants effilochés d\'un monde sauvage, leur armure ornée de scalps, de peaux et d\'os hideux, ces ornements que vous avez recupérer au fil de vos batailles ou acheter au premier commerçant venu. Beaucoup pensent que la compagnie ne peut être mise dans une case que ce soit en tant qu\'homme ou en tant que monstre.";
		this.m.SuccessButtonText = "Cela nous servira bien.";
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

