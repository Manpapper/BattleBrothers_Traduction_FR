this.wagon_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.wagon";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "A cart to carry our things is fine and all, but it won\'t do.\nLet\'s save up 15,000 crowns and buy us a real wagon!";
		this.m.RewardTooltip = "You\'ll unlock an additional 27 slots in your inventory.";
		this.m.UIText = "Have at least 15,000 Couronnes";
		this.m.TooltipText = "Gather the amount of 15,000 crowns or more, so that you can afford to buy a wagon for additional inventory space. You can make money by completing contracts, looting camps and ruins, or trading.";
		this.m.SuccessText = "[img]gfx/ui/events/event_158.png[/img]A wise man once told you that a wagon loses value the second it leaves the lot. The axiom dwells in the back of your head as you hand over 10,000 crowns for the wagon. But then you step up into the boxseat and jack your boot against the toeboard and feel right at home. You turn and take a look into the bed. There the wagonmaker installed a series of side-turned gates with iron spikes situated to hang trophies, pelts, and other goods. There is also a cage to hold a dog or a dog of a man if need be. A wooden toolbox with a heavy slaplatch carries all the means necessary to repair weapons and armor. Spare axles and wheels are held undercarriage.\n\nNodding, you turn back around and gander at the workhorse. The draught animal is a squat creature with muscled legs and an indifferent demeanor. It mindlessly crops the grass at its feet until you take up the jerkline and jockey it forward. The wagon trundles and tips and sags with nothing to suggest it was made to do anything you\'ve beckoned it to do. And yet there it goes.\n\n %randombrother% walks by swigging a wine bottle. When he asks how\'s the ride you steal his bottle and smash it across the wagon\'s side and yell out \'rawhide!\'";
		this.m.SuccessButtonText = "Finally.";
	}

	function onUpdateScore()
	{
		if (this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 4)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.cart").isDone())
		{
			return;
		}

		this.m.Score = 2 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 15000)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		this.World.Assets.addMoney(-10000);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/asset_money.png",
			text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]10,000[/color] Couronnes"
		});
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 27);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "Vous recevez 27 additional inventory slots"
		});
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

