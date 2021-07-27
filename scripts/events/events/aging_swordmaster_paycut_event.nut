this.aging_swordmaster_paycut_event <- this.inherit("scripts/events/event", {
	m = {
		Swordmaster = null
	},
	function create()
	{
		this.m.ID = "event.aging_swordmaster_paycut";
		this.m.Title = "Pendant le camp ...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]%swordmaster% entre dans votre tente. Vous lui faites signe de s\'asseoir sur la chaise en face de votre table. Il s\'assied si lentement et faiblement que vous craignez qu\'il mette deux fois plus de temps à se relever. L\'homme joint ses mains et s\'appuie sur la table avec ses bras, grogne et change de posture, ne trouvant pas de réconfort dans le fait de ne rien faire du tout. Ses lèvres sont sèches, son visage flétri. Des taches marquent sa tête et même les poils de son nez et de ses oreilles sont grises.\n\n Vous avez toujours du temps pour %swordmaster% vous demandez donc ce dont il veut discuter.%SPEECH_ON%Cela peut sembler étrange venant d\'un mercenaire, mais je pense que je vais le dire tout de même, et ça me fera mieux dormir la nuit. Je vais être direct, je ne suis plus l\'homme que vous aviez engagé autre fois. Vous le savez, je le sais. Quelques uns des hommes le savent, mais ils sont respectueux comme le sont les hommes bons.%SPEECH_OFF%Vous êtes d\'accord, mais n\'acquiescez pas. Au lieu de cela, vous demandez où il veut en venir.%SPEECH_ON%Je voudrais diminuer ma paie. Ne dîtes pas non, vous n\'as pas à me raconter de conneries. L\'argent n\'a jamais été un problème de toute façon. Ces couronnes pourraient être utilisées pour armer mieux les hommes ou même à mieux les payer. Dieu sait qu\'un jeune homme a toujours besoin d\'une couronne supplémentaire ou deux.%SPEECH_OFF%Avant que vous ne disiez un mot de plus, l\'homme se lève avec une rapidité surprenante. Il fait un signe de tête et un sourire enjoué avant de crier fort.%SPEECH_ON%Je suis d\'accord avec votre décision. Je pourrais bénéficier d\'une réduction de salaire!%SPEECH_OFF%Vous rigolez pendant que l\'homme quitte votre tente aussi rapidement qu\'il était entré.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Un homme honorable s\'il en a jamais été un.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				_event.m.Swordmaster.getBaseProperties().DailyWage -= _event.m.Swordmaster.getDailyCost() / 2;
				_event.m.Swordmaster.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Swordmaster.getName() + " est maintenant payé " + _event.m.Swordmaster.getDailyCost() + " Couronnes par jour"
				});
				_event.m.Swordmaster.getFlags().add("aging_paycut");
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.swordmaster" && !bro.getFlags().has("aging_paycut") && !bro.getSkills().hasSkill("trait.old"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Swordmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = this.m.Swordmaster.getLevel();
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"swordmaster",
			this.m.Swordmaster.getName()
		]);
	}

	function onClear()
	{
		this.m.Swordmaster = null;
	}

});

