this.taxidermist_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.taxidermist";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nothing commands respect as a trophy of a giant beast of the frozen wastes.\nLet\'s go hunt and get the taxidermist some work!";
		this.m.UIText = "Craft items at the taxidermist";
		this.m.TooltipText = "Have at least 12 items crafted from beast trophies at the taxidermist. A taxidermist can be found in settlements mostly near woods and swamp, and can craft useful items from trophies dropped by beasts, such as the unusually large wolf pelts dropped by direwolves.";
		this.m.SuccessText = "[img]gfx/ui/events/event_97.png[/img]A young boy hails you down and asks if you\'re the leader of the %companyname%. Eyeing the surrounding parts, you ask what it is to him. He shrugs.%SPEECH_ON%Well, I mean nothing by it, sir. If I find and fetch him I get paid three gold coins. Thas all.%SPEECH_OFF%Intrigued, you ask who it is set to pay this reward. The boy is picking a booger and looks up.%SPEECH_ON%Whussat? Ah, I ain\'t seen the gold yet! Gotta find the man first!%SPEECH_OFF%Sighing, you pull the boys\' hand aside, snot and all, and ask him again. The boy snorts, thinking, staring at the dirt, at the worms there. He nods.%SPEECH_ON%T\'was a taxman. Not the gold fetching sort. He\'d not pay me a coin, that man\'s a long-fingered devil so says my pa. I mean the animal taxman. Strips the beasts and fashions something fierce with them, coats, blankets, poisons, dranks. That taxman. Well, they all talkin\' to one another. They says the %companyname%\'s work makes for the best business in all the land and they all itching to meet them again!%SPEECH_OFF%Ah, he\'s speaking of the taxidermists. Smiling, you pat the boy on the head and wish him the best of luck in his hunt. He snorts and hocks a loogie.%SPEECH_ON%Luck ain\'t much all to do with this, I aim to find that man the learned way. Keepin\' my eyes open and ears peeled and my britches high and tight.%SPEECH_OFF%";
		this.m.SuccessButtonText = "The %companyname% presents its trophies proudly.";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(12, this.World.Statistics.getFlags().get("ItemsCrafted")) + "/12)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Statistics.getFlags().get("ItemsCrafted") >= 12)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		return this.World.Statistics.getFlags().get("ItemsCrafted") >= 12;
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

