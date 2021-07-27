this.aging_swordmaster_preview_event <- this.inherit("scripts/events/event", {
	m = {
		Swordmaster = null
	},
	function create()
	{
		this.m.ID = "event.aging_swordmaster_preview";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]Vous trouvez %swordmaster% assis sur une souche. Il regarde le paysage.%SPEECH_ON%Vous savez, j\'ai réalisé quelque chose en tant que vieil homme qui a travaillé bien trop longtemps dans ce business mortel. Je suis tellement plus sage maintenant. J\'ai appris à connaître tellement de choses, qui mon appris que je ne sais rien. Et je regarde en arrière et je me dis que j\'étais un crétin dans ma jeunesse. Puis j\'ai pensé, qu\'en est-il de tous les hommes que j\'ai tués, en arrêtant leur course mortelle alors qu\'ils étaient encore jeunes?%SPEECH_OFF%Vous prenez un siège et haussez les épaules. Il poursuit.%SPEECH_ON%Ce que j\'ai réalisé, c\'est que je suis un tueur de sagesse. J\'ai enlevé beaucoup de vieillards de ce monde, et avec eux, tant d\'experience et de connaissances. Il y a tellement de mondes là dehors que j\'ai détruit. Des mondes où ces hommes ont vécu et continué à vivre et ont fait les grandes choses qu\'ils ne savaient en être capable. Si le premier homme que j\'ai combattu m\'avait tué, combien de vies aurait-il sauvées ? Combien de sagesse aurait été épargnée? Je suis désolé, je ne voulais pas m\'éterniser.%SPEECH_OFF%L\'homme se lève, tapotant ses jambes flageolantes. Vous attrapez son bras.%SPEECH_ON%Avez-vous considéré que vous avez peut-être aussi sauvé des mondes? Que certains de ces hommes que vous avez tués auraient pu devenir d\'horribles monstres?%SPEECH_OFF%Il sourit, mais vous savez qu\'il y a déjà pensé et qu\'il ne veut pas vous déranger avec la réponse. Il acquiesce simplement avant de rejoindre le reste de la compagnie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'espère qu\'il va se remonter le moral.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				_event.m.Swordmaster.worsenMood(1.0, "Réalise qu\'il veilli");

				if (_event.m.Swordmaster.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Swordmaster.getMoodState()],
						text = _event.m.Swordmaster.getName() + this.Const.MoodStateEvent[_event.m.Swordmaster.getMoodState()]
					});
				}

				_event.m.Swordmaster.getFlags().add("aging_preview");
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.swordmaster" && !bro.getFlags().has("aging_preview") && !bro.getSkills().hasSkill("trait.old") && !bro.getFlags().has("IsRejuvinated"))
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

