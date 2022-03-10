this.oathtakers_noble_contracts_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.oathtakers_noble_contracts";
		this.m.Title = "Along the way...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_63.png[/img]{The men come to you with a startling discovery: on the inside cup of Young Anselm\'s brainpan was a tiny, rolled up letter - and its wax stamp bears the mark of a nobleman\'s ring. With agreement amongst the men, you tear it open and give it a read. You find that Young Anselm himself was of high birth, and that he had a writ of Curia in Absentia - or in mercenary parlance, an allowance to enter noble courts. You look out at the men and say,%SPEECH_ON%Young Anselm has blessed us all once again!%SPEECH_OFF%While the sensibilities of deracinated sellswords would prevent such scapegraces from ever talking with nobles, much less profaning their delicate stone floors, Young Anselm\'s letter carries a unique marker: anyone who is in his company will also gain the selfsame access, that includes this world or the next. The men surmise that Young Anselm must have held quite the high station in the noble circles for this to be the case, and that he must also have held your lot in high regard to offer the power to you.%SPEECH_ON%But, uhmm, who put the scroll inside his head?%SPEECH_OFF%%randombrother% inquires. You and the men tell him to shut his mouth. There\'s no point in dwelling on the how\'s and what\'s and why\'s. This is clearly a miracle and yet another acknowledgment that the Oathtakers are on the right path.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "With this writ, even the nobles will give us work.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Ambitions.getAmbition("ambition.make_nobles_aware").setDone(true);
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Nobles will now give you contracts"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1050)
		{
			return;
		}

		this.m.Score = 2000;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

