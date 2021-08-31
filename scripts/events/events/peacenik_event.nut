this.peacenik_event <- this.inherit("scripts/events/event", {
	m = {
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.peacenik";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_40.png[/img]Sur le chemin, vous croisez un homme qui regarde fixement un trou dans le sol. Naturellement, vous vous approchez et lui demandez ce qu\'il fait. Il dit qu\'il y a un orque dans le trou. Vous regardez en bas. Il y en a un. Vous sortez votre épée et vous demandez si vous pouvez vous en occuper pour lui. Il recule.%SPEECH_ON%Quoi ? Non ! Je le veux vivant. Je pense qu\'on peut essayer de le comprendre.%SPEECH_OFF%Comprendre ? Qu\'est-ce que cet homme veut dire ? Il supplie.%SPEECH_ON% Laissez-nous simplement essayer ! Tout le monde tue un orc à vue, mais ce ne sont pas de simples animaux. Ils font preuve d\'intelligence, et s\'ils ont de l\'intelligence cela signifie qu\'ils peuvent apprendre, et s\'ils peuvent apprendre alors peut-être qu\'ils peuvent apprendre à coexister avec nous.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Les chiens sont aussi intelligents, mais que faisons-nous des mauvais ?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Bien sûr. Bonne chance avec ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_40.png[/img]%houndmaster% le maître chien acquiesce et explique qu\'un animal, aussi intelligent ou bien dressé soit-il, reste un animal. Le pacifiste réfléchit un moment.%SPEECH_ON%I- ce n\'est pas un simple chien, pourtant!%SPEECH_OFF%Votre maître chien prend l\'homme par l\'épaule.%SPEECH_ON%Mais vous l\'avez acculé comme tel, n\'est-ce pas ? Que pensez-vous qu\'un homme ferait dans cette situation, avec toute son intelligence et sa sagesse, le dos au mur et des ennemis à l\'affût ? Ce n\'est ni l\'endroit ni le moment de faire la \"paix\", ami, que ce soit avec les hommes ou les bêtes.%SPEECH_OFF%L\'étranger commence lentement à hocher la tête. Il comprend le sens de l\'argument et, heureusement, te laisse détruire l\'orc sans aucun incident. Une fois la peau verte enlevée, l\'homme vous donne une sacoche de couronnes.%SPEECH_ON% Je voulais essayer de négocier avec lui en utilisant celles-ci. Ce n\'est plus le cas maintenant, clairement, et je serais probablement mort si vous n\'étiez pas arrivé. Considérez ceci comme mes remerciements, mercenaire.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous apprécions beaucoup.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				this.World.Assets.addMoney(50);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]50[/color] Couronnes"
				});
				_event.m.Houndmaster.getBaseProperties().Bravery += 1;
				_event.m.Houndmaster.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Houndmaster.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Détermination"
				});
				_event.m.Houndmaster.improveMood(1.0, "Il a donné une conférence sur la nature des animaux");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Houndmaster.getMoodState()],
					text = _event.m.Houndmaster.getName() + this.Const.MoodStateEvent[_event.m.Houndmaster.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.houndmaster")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Houndmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"houndmaster",
			this.m.Houndmaster.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Houndmaster = null;
	}

});

