this.anatomist_reflects_on_webknechts_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		OtherBro = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_reflects_on_webknechts";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{%anatomist% tend le bras et observe une araignée à longues pattes qui galope. Alors que la créature arrive au bout de sa nouvelle terre, l\'anatomiste tourne son bras, suggérant à l\'araignée de poursuivre son chemin autrement. Il fait cela pendant un certain temps, jusqu\'à ce qu\'il pose ses doigts vers le sol pour que l\'araignée s\'en aille, sans peut-être jamais se rendre compte qu\'elle était sur un être vivant. L\'anatomiste écrit quelques pages dans ses notes.%SPEECH_ON%L\'autre jour, j\'ai vu une araignée faire vingt fois la longueur de son corps pour attraper une mouche. Et cette araignée que j\'ai laissée partir, en voyant sa proie, a traversé le sol à toute vitesse comme un chien de chasse. Il semble que les dieux anciens aient eu pitié de nous car aucune de ces créatures ne peut être trouvée sous sa forme la plus grande, le webknecht.%SPEECH_OFF%Si être plaqué et déchiqueté serait assez terrible, vous lui dites qu\'être enveloppé dans un cocon avant de se faire sucer le sang par des crocs est sans doute pire. L\'anatomiste lève un doigt.%SPEECH_ON%Une idée fausse, car le webknecht préfère en fait se nourrir longtemps après votre mort. Nous pensons que ses toxines sont conçues pour cibler le ventre, l\'ouvrir et utiliser ses fluides pour vous faire fondre de l\'intérieur. C\'est sans doute pour cela qu\'ils pendent leurs proies la tête en bas, pour que les toxines puissent se répandre sur les organes, vous transformant en une sorte de sac de fluides. La phase de consommation du processus consiste simplement à digérer ce qui reste. Le seul cas où elles ne vous mangent pas est lorsqu\'elles placent leur couvée à l\'intérieur de vous, car les araignées auront besoin de nourriture après l\'éclosion.%SPEECH_OFF%Cela semble toujours infiniment pire que d\'être piqué par une araignée en chasse, mais dans tous les cas, vous regrettez d\'avoir eu cette conversation et ne la poursuivez pas. Malheureusement, %otherbro% n\'est pas loin et n\'a que trop entendu...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Arrêtez de répandre la peur, bon sang.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.OtherBro.getImagePath());
				local trait = this.new("scripts/skills/traits/fear_beasts_trait");
				_event.m.OtherBro.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.OtherBro.getName() + " now fears beasts"
				});
				_event.m.OtherBro.worsenMood(1.0, "Terrified of spiders");

				if (_event.m.OtherBro.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.OtherBro.getMoodState()],
						text = _event.m.OtherBro.getName() + this.Const.MoodStateEvent[_event.m.OtherBro.getMoodState()]
					});
				}

				_event.m.Anatomist.improveMood(1.0, "Fascinated with spiders");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.beast_slayer" && bro.getBackground().getID() != "background.wildman" && !bro.getSkills().hasSkill("trait.brave") && !bro.getSkills().hasSkill("trait.fearless") && !bro.getSkills().hasSkill("trait.fear_beasts") && !bro.getSkills().hasSkill("trait.hate_beasts"))
			{
				other_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0 || other_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.OtherBro = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = 2 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"otherbro",
			this.m.OtherBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.OtherBro = null;
	}

});

