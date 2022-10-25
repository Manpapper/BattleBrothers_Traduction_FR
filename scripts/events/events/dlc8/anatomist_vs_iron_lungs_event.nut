this.anatomist_vs_iron_lungs_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		IronLungs = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_ironlungs";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Avoir une excellente endurance est très important dans le monde du mercenariat, mais il est clair que certains hommes sont bien plus à même de lutter contre la fatigue que d\'autres. %ironlungs% est l\'un de ces hommes, un combattant réputé pour sa capacité à maintenir un souffle régulier pendant une longue bataille harassante. Pour vous, ce n\'est rien de plus qu\'une curiosité, comme lorsqu\'un homme a un cou bizarre, des mains énormes ou un gros marteau entre les jambes. Mais pour %anatomist%, c\'est tout autre chose. Il souhaite savoir comment un homme peut avoir des poumons aussi robustes et puissants alors que son quotidien est peu différent de celui de son entourage.%SPEECH_ON%Nous sommes tous des combattants ici, alors comment se fait-il que cet homme puisse respirer à un rythme aussi régulier par rapport à nous? Il possède sûrement un atout que nous n\'avons pas, et je pense être capable de le trouver.%SPEECH_OFF%Attendez, les \"nous\" sont tous des combattants ici? Vous n\'iriez pas aussi loin, mais vous ne corrigerez pas l\'anatomiste. Vous lui demandez comment il étudierait exactement cette question.%SPEECH_ON%Une simple dissection ne serait pas une digression, tout bien considéré, mais je crois que %ironlungs% refuserait la demande. Il ne me reste donc qu\'une seule option: l\'étudier attentivement et voir si je peux reproduire ses qualités en manipulant mes os et en pratiquant des incisions minutieuses.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Votre corps, vos choix.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Hors de question.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous dites à l\'anatomiste de continuer à faire ce qu\'il veut. Il sort une plume d\'oie et quelques livres, puis une sacoche remplie de pinces métalliques, de ciseaux et de scalpels. Il vérifie la propreté de chacun d\'eux, puis les prend et se dirige vers %ironlungs%. Le mercenaire répond par des regards gênés. L\'anatomiste finit par convaincre l\'homme de l\'accompagner dans une tente avec lui. Vous gardez un œil sur ce qu\'il se passe au cas où l\'anatomiste perdrait la tête et deviendrait un fou furieux. Finalement, %anatomist% revient avec une fiole en main qu\'il fait tournoyer un moment, puis boit. Il hoche la tête.%SPEECH_ON%J\'espère que ça va marcher. J\'ai soumis mon propre corps à de fortes contraintes, pour vraiment stresser les poumons, puis j\'ai ajouté quelques ingrédients fournis par %ironlungs% lui-même. Ce sont des éléments supplémentaires que je ne divulguerai à personne, jamais, car si cela fonctionne, je serai peut-être l\'expert dans son domaine, un véritable héros des sciences, et j\'aurai une longueur d\'avance sur les autres anatomistes.%SPEECH_OFF%Très bien. %ironlungs% sort maintenant de la tente. Vous lui demandez ce qui s\'est passé. L\'homme hausse les épaules.%SPEECH_ON%Je lui ai dit que je m\'étirais beaucoup, que j\'avais une bonne posture et que je travaillais ma respiration de temps en temps. Il a refusé ces réponses, se convainquant qu\'il devait y avoir un autre moyen. Puis il est devenu complètement cinglé avec les outils qu\'il avait et a commencé à, euh, \"travailler\" sur lui-même. Ce qu\'il a fait avait l\'air très douloureux, mais il l\'a supporté sans broncher.%SPEECH_OFF%Attendez, vous travaillez votre respiration?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je suis maintenant capable de maitriser ma respiration.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local trait = this.new("scripts/skills/traits/iron_lungs_trait");
				_event.m.Anatomist.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Anatomist.getName() + " gains Iron Lungs"
				});
				local injury = _event.m.Anatomist.addInjury([
					{
						ID = "injury.pierced_lung",
						Threshold = 0.0,
						Script = "injury/pierced_lung_injury"
					}
				]);
				this.List.push({
					id = 11,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " suffers " + injury.getNameOnly()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%anatomist% reçoit le feu vert, il se retire précipitamment dans sa tente avec un sac d\'outils et %ironlungs%. Vous entrez dans la tente pour trouver %anatomist% assis droit comme un I, puis il se penche comme un vieillard à la colonne vertébrale froissée par la fatigue, puis se redresse.\n\nSoudain, il prend un de ses outils et se perfore avec. %ironlungs% recule, un peu choqué par un tel acte d\'autodestruction. Il tend la main pour aider l\'anatomiste, mais celui-ci le repousse. En serrant les dents, %anatomist% commence à écrire des notes alors que du sang sort de sa bouche avant de se répandre sur les pages. Puis il répète le processus, cette fois sous un autre angle.\n\nMême de loin, on peut maintenant voir le sang rouge foncé jaillir. Il serre les dents et se plante une nouvelle fois. Cette fois, un grand jet cramoisi gicle dans tous les sens. Vous en avez vu assez, mais avant que vous puissiez enfin intervenir, les yeux de l\'anatomiste se révulsent et il s\'évanouit, %ironlungs% est choqué.%SPEECH_ON%C\'est quoi ce bordel? Vous êtes d\'accord avec ça, capitaine? Qu\'espérait-il apprendre?%SPEECH_OFF%Vous n\'êtes pas assez payé pour supporter ces crétins. En regardant les notes de l\'anatomiste, vous pouvez voir à travers la page ensanglantée qu\'il a simplement écrit \"ne pas travailler\" encore et encore.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quand le simple fait de respirer fait de vous un garçon ennuyeux.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local injury = _event.m.Anatomist.addInjury([
					{
						ID = "injury.pierced_lung",
						Threshold = 0.0,
						Script = "injury/pierced_lung_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Anatomist.worsenMood(0.5, "His experimental surgery didn\'t work");
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous dites à l\'anatomiste de s\'occuper de ses affaires. Alors qu\'il fait des siennes et que cela vous concerne de plus en plus, vous lui dites que %ironlungs% est un homme à part entière et qu\'il n\'y a rien à tirer de son existence, si ce n\'est un minimum d\'admiration. Et c\'est tout. %anatomist% ouvre la bouche pour répondre, puis la referme. Au lieu de cela, ce à quoi il pensait est consigné dans ses notes. Vous espérez que le drame qu\'il y a derrière séchera en même temps que son encre.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Foutus intellos",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Was denied a research opportunity");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local ironLungsCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && !bro.getSkills().hasSkill("trait.iron_lungs"))
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.anatomist" && bro.getSkills().hasSkill("trait.iron_lungs"))
			{
				ironLungsCandidates.push(bro);
			}
		}

		if (ironLungsCandidates.len() == 0 || anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.IronLungs = ironLungsCandidates[this.Math.rand(0, ironLungsCandidates.len() - 1)];
		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 5 * ironLungsCandidates.len();
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
			"ironlungs",
			this.m.IronLungs.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.IronLungs = null;
	}

});

