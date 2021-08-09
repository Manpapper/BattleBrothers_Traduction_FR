this.historian_mysterious_text_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null
	},
	function create()
	{
		this.m.ID = "event.historian_mysterious_text";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_57.png[/img]Vous tombez sur une chapelle abandonnée. Des toiles d\'araignée recouvrent ses fissures, et des nids d\'oiseaux ses coins. Les bancs sont renversés ou ont été coupés pour faire du bois de chauffage. Les anciens dieux ont sûrement quitté cet endroit.\n\n %historian% l\'historien vient vers vous avec ce qui ressemble à des bûches boueuses dans les mains.%SPEECH_ON% Voyez-vous ça ? De vieux parchemins!%SPEECH_OFF%Il souffle sur la poussière et la cendre noircie des parchemins.%SPEECH_ON%Avez-vous déjà vu quelque chose d\'aussi spectaculaire ? Je ne sais pas encore ce qu\'ils disent, mais c\'est quand même une découverte des plus intéressantes!%SPEECH_OFF%D\'accord, peu importe.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Juste lis-le et dis-moi ce qu\'il dit déjà.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_15.png[/img]Alors que vous campez à l\'extérieur du temple, %historian% l\'historien entre dans votre tente.%SPEECH_ON%Boss, je pense que ceci pourrait vous intéresser.%SPEECH_OFF%Il a les parchemins de la chapelle dans les bras et en déroule quelques-uns sur votre bureau. Vous y voyez les gribouillages peu soignés de l\'historien. Ses notes sont dans une langue que vous ne pouvez pas lire, mais vous pouvez facilement suivre les flèches qu\'il a tracées sur les pages pour relier des segments entre eux. Il déroule ensuite un autre parchemin, tout neuf, avec toutes les traductions.%SPEECH_ON%Ce sont de vieux manuels d\'entraînement. Ils parlent de techniques dont j\'ignorais l\'existence. Dois-je les distribuer aux hommes ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Les distribuer, tu devrais.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.getBaseProperties().RangedDefense += 1;
					bro.getSkills().update();
					this.List.push({
						id = 16,
						icon = "ui/icons/ranged_defense.png",
						text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Défense à Distance"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_15.png[/img]Alors que vous êtes assis dans votre tente à l\'extérieur du temple abandonné, %historian% l\'historien entre d\'une manière que l\'on pourrait qualifier de réticente. Dans ses mains se trouvent les parchemins qu\'il a trouvé dans la chapelle il y a quelques jours.%SPEECH_ON%Boss, euh, les parchemins... ils étaient très intéressants.%SPEECH_OFF%Ennuyé, vous demandez \"à quel point\". L\'homme explique.%SPEECH_ON%Eh bien, ils ont été écrits dans une langue très ancienne. Je ne la connais pas très bien, mais je peux certainement en lire des parties ici et là.%SPEECH_OFF%Vous lui demandez alors ce qu\'il veut.%SPEECH_ON%J\'aimerais lire les parchemins, mais j\'aurais besoin d\'un peu de soutien avant de le faire. Voulez-vous faire la bénédiction de la lecture ? C\'est ce que mes anciens professeurs faisaient avant toute grande tâche.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Très-bien, vas-y, lis.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "D";
						}
						else
						{
							return "E";
						}
					}

				},
				{
					Text = "Si tu as si peur de lire, il vaut peut-être mieux ne pas le faire.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_12.png[/img]%historian% ramasse les parchemins. Il se lèche les lèvres, se racle la gorge et commence à lire à haute voix. Les mots qui sortent ne sont pas de ceux que l\'on reconnaît facilement. Ils sonnent de façon si paresseuse, comme s\'il s\'agissait d\'un homme que l\'on tire d\'un profond sommeil, et qu\'il amenait avec lui les monstres qui peuplent les mondes oniriques.\n\n Il s\'arrête et lève les yeux.%SPEECH_ON% C\'était tout. Vous sentez quelque chose ? %SPEECH_OFF%Vous levez un sourcil. Je ne ressens rien ? Pourquoi devrais-je... Démence. Vous voyez une spirale de ténèbres enveloppée d\'ombres vivantes, les spectres hurlants de créatures qui aspirent encore à la finalité de la mort, et parmi eux tourbillonnent des êtres, souriant et jappant, comme des marionnettistes bestiaux, les gueules glissées jusqu\'aux profondeurs, leurs dents osseuses étant la seule lumière de ce royaume, leurs sourires n\'étant que des croissants de lunes mal formées venues se repaître des étoiles elles-mêmes. %SPEECH_ON%Oh petit naïf, pensais-tu que Davkul n\'écoutait pas ? %SPEECH_OFF%Vous vous réveillez soudainement avec les cris de %historian%. Il dit que toutes sortes de monstres sont en liberté. Sans perdre un instant, vous allez prévenir les hommes avant que tous les enfers et ceux qui ne sont pas encore connus ne se déchaînent.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aux Armes!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Direwolves, this.Math.rand(40, 70), this.Const.Faction.Enemy);
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Ghouls, this.Math.rand(40, 70), this.Const.Faction.Enemy);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_15.png[/img]%historian% prend le parchemin et commence à lire. La langue est à la fois familière et primordialement ancienne. Elle chatouille l\'oreille comme le grattement des vipères sur le sable et n\'en est pas moins menaçante. Quand il a fini, l\'historien lève les yeux.%SPEECH_ON%Vous sentez quelque chose ? %SPEECH_OFF%Soudain une main sombre mais douce entoure l\'homme par derrière, descendant vers ses reins.%SPEECH_ON%Oh, humains. Nous ne pensions pas que vous survivriez aussi longtemps, et en effet cela fait longtemps que l\'on n\'a pas fait appel à nos services.%SPEECH_OFF%Les créatures qui se déhanchent se glissent si légèrement dans la tente comme si elles n\'étaient guère plus que le vent lui-même. Dehors, vous pouvez entendre le murmure du reste de la compagnie qui se laisse envahir par les êtres séduisants. L\'une d\'entre elles s\'avance vers vous, sa silhouette passant par toutes les femmes de votre vie, testant votre réaction, et lorsque votre cœur se réchauffe, elle se pose sur une jeune femme qui vous a autrefois brisé le cœur. La succube tombe sur vous.%SPEECH_ON%Ne fais pas attention à moi, humain, c\'est pour toi. Détends-toi.%SPEECH_OFF%Vous laissez les plaisirs vous envahir.\n\nDes heures innombrables plus tard vous vous réveillez avec votre pantalon baissé et %historian% dans le coin se frottant la tête.%SPEECH_ON%Elles étaient si merveilleuses, mais le parchemin a disparu. Je pense qu\'il a brûlé après que j\'ai prononcé les mots. Oh par les vieux dieux, j\'aimerais me souvenir de ce qu\'elles ont dit!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Incroyable.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(1.0, "A eu une expérience surnaturelle agréable");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 10)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 8)
			{
				nearTown = true;
				break;
			}
		}

		if (nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_historian = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.historian")
			{
				candidates_historian.push(bro);
			}
		}

		if (candidates_historian.len() == 0)
		{
			return;
		}

		this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Historian = null;
	}

});

