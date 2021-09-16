this.cultural_conflagration_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.cultural_conflagration";
		this.m.Title = "During camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_175.png[/img]{Shouting and yelling drags you from counting inventory. You find a few of the men standing at opposite ends of the campfire pointing fingers and even a weapon or two. Seems there\'s a bit of a dustup over whose women are more beautiful: southerners or northerners. Ironically, the northerners are voting for the southerners and vice versa. A couple of stern commands brings order back to the company, but the tensions remain. | There\'s been a bit of fisticuffs between some of the men. Apparently, there was a disagreement about the marriage rites between men and women. The northerners believe it should be one and one, while the southerners prefer marrying as many women as one can get their hands on. You tell the men to stop fighting like women and focus on the task at hand, which may or may not be to finish a job to get coin to then spend on a woman, but that\'s neither here nor there. | A couple of the men get into it over some religious differences. Some conflict over the old gods and the Gilder, each man a little ambassador of his faith, diplomatically putting fists into the opposition\'s faces. You tell them all to quit it and get their heads straight. If they want to argue over which gods are best, they can do it in the afterlife. | A couple of the men get into it over matters of... sand? It seems the northerners in the company are poking fun at the southerners, asking how stupid one would have to be to settle in a land with nothing but sand.%SPEECH_ON%Who looks around in a hot arse sandy dune and thinks, aye, this\'ll be my home. Bet you wish yer forefathers had a proper mind to realize there\'s more to the world than a gods damned forever sunburn.%SPEECH_OFF%This garners the first punch thrown. The scuffle has a few injured, but you get the men back to order, commanding them to keep their geographic opinions to themselves. | An argument breaks out when southerners in the company start poking fun at their northern brothers\' lack of articulation. One mimics with his hands splayed out at his ears.%SPEECH_ON%We\'s all talks like this, aye, yessir, ain\'t y\'all ready to come on to somesuch sumbitch thing, aye? Ain\'t ain\'t ain-%SPEECH_OFF%Fisticuffs end the jestering. A few are bruised in the exchange, but you manage to break it up before it gets more serious. | Though normally dismissive of their overlords, the northerners and the southerners take to defending the lords and Viziers of their lands respectively. It seems the foil of having some cultural opposition has spurred heretofore unseen fealties. The arguments unwind into an actual fist fight, with not a lord around to be impressed, mind. You break it up, telling them the only one they should look to impress is either you or each other as brothers in battle.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Why can\'t we all just get along?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							bro.improveMood(0.5, "Had a brawl over cultural differences");
						}
						else
						{
							bro.worsenMood(0.5, "Had a brawl over cultural differences");
						}

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}

					if (this.Math.rand(1, 100) <= 40)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " suffers light wounds"
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() <= 5)
		{
			return;
		}

		local northern = 0;
		local southern = 0;

		foreach( bro in brothers )
		{
			if (bro.getEthnicity() == 0)
			{
				northern = ++northern;
			}
			else
			{
				southern = ++southern;
			}
		}

		if (northern <= 1 || southern <= 1)
		{
			return;
		}

		this.m.Score = this.Math.min(northern, southern) * 2;
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

