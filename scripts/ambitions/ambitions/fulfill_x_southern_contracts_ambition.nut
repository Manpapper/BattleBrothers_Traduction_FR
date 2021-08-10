this.fulfill_x_southern_contracts_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		ContractsToFulfill = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.fulfill_x_southern_contracts";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "The city states of the south have crowns aplenty.\nWe shall get rich under the blazing desert sun!";
		this.m.UIText = "Fulfill contracts for the city states";
		this.m.TooltipText = "Travel south, visit the southern city states and find employment there. Take on and complete contracts for the ruling elite.";
		this.m.SuccessText = "[img]gfx/ui/events/event_150.png[/img]For all their intellectual pursuits and proper mannerisms, the Southerners are under no misapprehension as to your role as a mercenary. Whereas in the north they\'d call you sellsword, here they dub you crownling. You\'ve spent little mind toward either attribution, recognizing only the stark reality that for as much as they despise you, they seek out your work, award your competency, and remember your billing when future crises arise.\n\n And therein lies the cornerstone of the North and South: the mighty crown itself. Languages, religion, peoples, all be damned. A bit of gold needs no translation, no accommodation, and no arbitration. Your pursuit of the crown has shown you to be reliable to the Southerners, and your renown has grown as deep as their pockets.";
		this.m.SuccessButtonText = "Gold is gold.";
	}

	function getUIText()
	{
		local d = 5 - (this.m.ContractsToFulfill - this.World.Statistics.getFlags().getAsInt("CityStateContractsDone"));
		return this.m.UIText + " (" + this.Math.min(5, d) + "/5)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("CityStateContractsDone") > 15)
		{
			return;
		}

		this.m.ContractsToFulfill = this.World.Statistics.getFlags().getAsInt("CityStateContractsDone") + 5;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("CityStateContractsDone") >= this.m.ContractsToFulfill)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.ContractsToFulfill);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.ContractsToFulfill = _in.readU16();
	}

});

