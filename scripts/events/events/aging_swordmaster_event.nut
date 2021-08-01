this.aging_swordmaster_event <- this.inherit("scripts/events/event", {
	m = {
		Swordmaster = null
	},
	function create()
	{
		this.m.ID = "event.aging_swordmaster";
		this.m.Title = "Sur le chemin...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]Vous trouvez %swordmaster% lutter pour s\'installer sur un tronc d\'arbre. Alors qu\'il s\'abaisse avec précaution, vous voyez ses jambes trembler comme si elles ne pouvaient pas se plier du tout. Il laisse échapper un long soupir après s\'être assis. Son épée à ses côtés. Elle est plus récente que la main qui la tien, un remplacement d\'un remplacement d\'un remplacement. Il ne montre d\'affection pour l\'épée, mais quand il la touche on dirait qu\'il existe une sorte de simbiose, sur la façon dont un homme s\'allonge avec son épée, et comment il raccourcit les autres par cette même lame. Vous vous tournez pour partir, espérant donner au maître d\'armes du temps pour lui, mais il remarque votre départ et vous appelle.%SPEECH_ON%Bonjour, capitaine. Je ne voulais pas que vous voyiez ça%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Comment vas-tu?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Eh bien, je l\'ai vu. Maintenant, allons-y.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_17.png[/img]Il se penche en arrière, frottant un de ses genoux avec se main calleuse. Un peu de vent fait bouger sa touffe de cheveux grisonnants.%SPEECH_ON%Vieux. C\'est comment je vais. Et je ne parle pas de mon âge. Avec les années, je suis vieux depuis un moment maintenant. Je veux dire que je suis vieux jusqu\'aux os. j\'imagine que maintenant c\'est plus ma réputation qui me précède que mes compétences.%SPEECH_OFF%Vous n\'êtes pas d\'accord, vous lui dites qu\'il est l\'un des hommes les plus mortels que vous ayez jamais rencontrés.%SPEECH_ON%Gardez les civilités pour les femmes, capitaine. Ma vue baisse. Vous vouliez probablement pas entendre ça, mais c\'est le cas. Mon pied avant ne marche plus comme avant. Le genou craque, et se bloque. Et un de ces jours ça m\'en coutera. Je ne sens plus ma main non-dominante.%SPEECH_OFF%Le maître d\'armes serre et desserre sa main libre.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous sentez quelque chose ?",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_17.png[/img]%SPEECH_ON%Rien. Je suppose que les nerfs sont en train de mourir. Et parfois j\'oublie des choses. Je ne parle pas d\'où j\'ai laissé mes chaussures non plus. J\'oublie s\'il y a quelqu\'un derrière moi ou non. Mon sens de l\'environnement, ma vraie lame, a été émoussé. Malgré toute ma rapidité et mon instinct, c\'est le temps qui s\'est insinué en moi, lentement, petità petit, sans crier gare, il est simplement apparu.... J\'ai toujours pensé que je serais battu par un autre maître de l\'épée. Quelqu\'un avec du talent. Mais j\'imagine que j\'étais trop bon pour ça.%SPEECH_OFF%Le maître de l\'épée sourit. Vous demandez s\'il craint une mort sans honneur..%SPEECH_ON%J\'ai réalisé il y a longtemps que quand que vous devenez quelqu\'un avec ma réputation, n\'importe quel chemin qui me mènera à la mort sera décevante. Ils écriront dans les livres que quelqu\'un d\'inférieur m\'a tué moi le grand maître de l\'épée. C\'est de la foutaise. Si vous voulez la vérité, je vais vous la dire. J\'ai peur car je sais ce qu\'il va m\'arriver. C\'est que mon corps me trahira au dernier moment. Avec le temps à ses côtés, c\'est mon corps qui me tuera, pas quelqu\'un d\'autre. Mon genou qui se bloquera ma main qui ne serrera plus assez fort ou encore mon épaule qui faiblira. Je n\'ai pas peur de la mort. J\'étais trop bon poru la mort, donc la mort devra attendre. Mon corps me tuera en premier, puis la mort pourra avoir ce qu\'il reste, ce pauvre corps noirci. Les écrivains et les historians? Je leur pisse dessus. Si j\'avais voulu la gloire éternel, je serais parti combattre une armée tout seul.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "De ce que j\'ai entendu,tu la déjà fait.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_17.png[/img]Le vieux maître de l\'épée vous sourit. %SPEECH_ON%Oh, laissez tomber, capitaine. Maintenant aide-moi à me relever pour qu\'on puisse reprendre la route.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le temps continue d\'avancer.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				local old_trait = this.new("scripts/skills/traits/old_trait");
				_event.m.Swordmaster.getSkills().add(old_trait);
				_event.m.Swordmaster.setHitpoints(this.Math.min(_event.m.Swordmaster.getHitpoints(), _event.m.Swordmaster.getHitpointsMax()));
				this.List = [
					{
						id = 13,
						icon = old_trait.getIcon(),
						text = _event.m.Swordmaster.getName() + " a vieilli"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_17.png[/img]Vous entendez le vieux maître de l\'épée soupirer alors que vous vous éloignez. Suivre le reste de la compagnie semble être devenu une bataille en soi pour lui.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le temps continue d\'avancer.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				local old_trait = this.new("scripts/skills/traits/old_trait");
				_event.m.Swordmaster.getSkills().add(old_trait);
				_event.m.Swordmaster.setHitpoints(this.Math.min(_event.m.Swordmaster.getHitpoints(), _event.m.Swordmaster.getHitpointsMax()));
				this.List = [
					{
						id = 13,
						icon = old_trait.getIcon(),
						text = _event.m.Swordmaster.getName() + " a vieilli"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 9 && bro.getBackground().getID() == "background.swordmaster" && !bro.getSkills().hasSkill("trait.old") && !bro.getFlags().has("IsRejuvinated"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Swordmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = this.m.Swordmaster.getLevel() - 5;
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

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Swordmaster = null;
	}

});

