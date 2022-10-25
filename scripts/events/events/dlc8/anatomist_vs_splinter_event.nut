this.anatomist_vs_splinter_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		SplinterBro = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_splinter";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 110.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{Vous trouvez %anatomist% qui tient le pied nu de %splinterbro%. Naturellement, vous demandez ce qu\'ils font. L\'anatomiste se redresse, une pince à épiler à la main et, pincée entre ses dents, une énorme écharde. %splinterbro% remue les orteils puis se lève. Il se promène, puis plante rapidement son pied à terre, il se met à le faire pivoter de droite à gauche.%SPEECH_ON%Que je sois damné. Je pensais que je m\'étais juste cassé le pied ou quelque chose comme ça, il s\'avère que j\'ai juste marché avec une énorme écharde pendant des année! Ça fait du bien!%SPEECH_OFF%Au lieu de jeter l\'écharde, %anatomist% la confine dans une boîte en bois où roulent d\'autres bizarreries médicales.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je ne vous vois pas utiliser ça comme un cure-dent.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.SplinterBro.getImagePath());
				_event.m.SplinterBro.getBaseProperties().MeleeDefense += 1;
				_event.m.SplinterBro.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.SplinterBro.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Melee Defense"
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

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local splinter_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.bright") && bro.getBackground().getID() != "background.monk" || bro.getBackground().getID() != "background.historian" || bro.getBackground().getID() != "background.adventurous_noble" || bro.getBackground().getID() != "background.disowned_noble" || bro.getBackground().getID() != "background.regent_in_absentia" || bro.getBackground().getID() != "background.minstrel")
			{
				splinter_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0 || splinter_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.SplinterBro = splinter_candidates[this.Math.rand(0, splinter_candidates.len() - 1)];
		this.m.Score = 3 * anatomist_candidates.len();
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
			"splinterbro",
			this.m.SplinterBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.SplinterBro = null;
	}

});

