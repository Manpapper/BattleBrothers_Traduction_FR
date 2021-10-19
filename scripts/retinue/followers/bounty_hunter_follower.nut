this.bounty_hunter_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.bounty_hunter";
		this.m.Name = "Le Chasseur de Primes";
		this.m.Description = "Ce chasseur de primes haut en couleur a une poche pleine de contrats sur les individus les plus dangereux. Il sait comment les faire sortir de leur cachette et paiera grassement pour toute prime remplie.";
		this.m.Image = "ui/campfire/bounty_hunter_01";
		this.m.Cost = 4000;
		this.m.Effects = [
			"Augmente considérablement les chances de rencontrer des champions.",
			"Paie entre 300 et 750 couronnes pour chaque champion tué."
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = ""
			}
		];
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

	function onUpdate()
	{
		this.World.Assets.m.ChampionChanceAdditional = 3;
	}

	function onEvaluate()
	{
		local nameditems = this.getNumberOfNameditems();
		this.m.Requirements[0].Text = "Ayez " + this.Math.min(3, nameditems) + "/3 objets nommés ou légendaires en votre possession";

		if (nameditems >= 3)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

	function onChampionKilled( _champion )
	{
		if (this.Tactical.State.getStrategicProperties() == null || !this.Tactical.State.getStrategicProperties().IsArenaMode)
		{
			this.World.Assets.addMoney(this.Math.floor(_champion.getXPValue()));
		}
	}

	function getNumberOfNameditems()
	{
		local n = 0;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)) && item.getID() != "armor.head.fangshire")
			{
				n = ++n;
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				n = ++n;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

			if (item != null && item != "-1" && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				n = ++n;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)) && item.getID() != "armor.head.fangshire")
			{
				n = ++n;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				n = ++n;
			}

			for( local i = 0; i < bro.getItems().getUnlockedBagSlots(); i = ++i )
			{
				local item = bro.getItems().getItemAtBagSlot(i);

				if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
				{
					n = ++n;
				}
			}
		}

		return n;
	}

});

